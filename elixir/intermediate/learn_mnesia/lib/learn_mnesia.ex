defmodule LearnMnesia do
  @moduledoc """
  Mnesia — Erlang's built-in distributed database.

  Mnesia is part of OTP (no extra deps). It provides:
    - In-memory and disk-persistent tables
    - ACID transactions
    - Replication across nodes
    - Both SQL-like queries and key-value access
    - Dirty (non-transactional) operations for speed

  It's the oldest and most Erlang-native database solution.
  Used in production by RabbitMQ, WhatsApp (historically), and others.
  Mria (from EMQX) is a modern replication layer built on top of it.

  No extra deps — Mnesia is in OTP:
    extra_applications: [:mnesia]
  """

  def run do
    IO.puts("\n=== Mnesia: Erlang's Built-in Distributed DB ===\n")

    setup()
    basic_crud()
    transactions()
    querying()
    dirty_operations()
    table_types()
    teardown()
  end

  # -----------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------
  defp setup do
    IO.puts("--- Setup ---")

    # Start Mnesia (creates schema in memory by default)
    :mnesia.start()

    # create_table/2 — define a table
    # Record format: {TableName, key_field, field2, field3, ...}
    :mnesia.create_table(:users, [
      attributes: [:id, :name, :email, :age],
      type: :set  # :set (default), :bag, :ordered_set
      # disc_copies: [node()] — persist to disk
      # ram_copies: [node()] — RAM only (default)
    ])

    :mnesia.create_table(:sessions, [
      attributes: [:token, :user_id, :created_at],
      type: :set
    ])

    IO.puts("Tables created: #{inspect(:mnesia.system_info(:tables))}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # Basic CRUD
  # -----------------------------------------------------------------------
  defp basic_crud do
    IO.puts("--- Basic CRUD (inside transactions) ---")

    # All writes go through transactions for safety
    {:atomic, :ok} = :mnesia.transaction(fn ->
      # write/1 — insert or replace (upsert by primary key)
      :mnesia.write({:users, 1, "Alice", "alice@example.com", 30})
      :mnesia.write({:users, 2, "Bob",   "bob@example.com",   25})
      :mnesia.write({:users, 3, "Carol", "carol@example.com", 35})
    end)

    # Read inside a transaction
    {:atomic, result} = :mnesia.transaction(fn ->
      # read/2 — returns a list (may have 0 or 1 elements for :set tables)
      :mnesia.read(:users, 1)
    end)
    IO.puts("Read user 1: #{inspect(result)}")

    # Update (just write with same key — upsert semantics)
    {:atomic, :ok} = :mnesia.transaction(fn ->
      [{:users, 1, name, email, _age}] = :mnesia.read(:users, 1)
      :mnesia.write({:users, 1, name, email, 31})  # update age
    end)

    {:atomic, [updated]} = :mnesia.transaction(fn -> :mnesia.read(:users, 1) end)
    IO.puts("After update: #{inspect(updated)}")

    # Delete
    {:atomic, :ok} = :mnesia.transaction(fn ->
      :mnesia.delete({:users, 3})  # delete by key
    end)

    IO.puts("After delete, users: #{inspect(get_all_users())}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # Transactions
  # -----------------------------------------------------------------------
  defp transactions do
    IO.puts("--- Transactions: ACID guarantees ---")

    # Transactions are retried automatically on deadlock
    # :mnesia.abort/1 rolls back
    result = :mnesia.transaction(fn ->
      :mnesia.write({:sessions, "tok_abc", 1, DateTime.utc_now()})
      :mnesia.write({:sessions, "tok_xyz", 2, DateTime.utc_now()})

      sessions = :mnesia.match_object({:sessions, :_, :_, :_})
      length(sessions)
    end)

    IO.puts("Committed #{elem(result, 1)} sessions")

    # Intentional abort (rollback)
    abort_result = :mnesia.transaction(fn ->
      :mnesia.write({:sessions, "tok_bad", 999, DateTime.utc_now()})
      :mnesia.abort(:my_custom_reason)
    end)
    IO.puts("Aborted transaction: #{inspect(abort_result)}")

    # Confirm bad session was NOT written
    {:atomic, bad} = :mnesia.transaction(fn -> :mnesia.read(:sessions, "tok_bad") end)
    IO.puts("Bad session (should be empty): #{inspect(bad)}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # Querying
  # -----------------------------------------------------------------------
  defp querying do
    IO.puts("--- Querying ---")

    # match_object/1 — pattern match (underscore = wildcard)
    {:atomic, matches} = :mnesia.transaction(fn ->
      :mnesia.match_object({:users, :_, :_, :_, :_})
    end)
    IO.puts("All users via match_object: #{inspect(matches)}")

    # select/2 — ETS-style match spec (more powerful)
    {:atomic, names} = :mnesia.transaction(fn ->
      :mnesia.select(:users, [
        {{:users, :"$1", :"$2", :_, :"$3"},  # pattern
         [{:>, :"$3", 25}],                   # guard: age > 25
         [:"$2"]}                             # return: name
      ])
    end)
    IO.puts("Users over 25: #{inspect(names)}")

    # foldl/3 — fold over all records
    {:atomic, total_age} = :mnesia.transaction(fn ->
      :mnesia.foldl(fn {:users, _id, _name, _email, age}, acc ->
        acc + age
      end, 0, :users)
    end)
    IO.puts("Total age: #{total_age}")

    # index_read — requires creating an index first
    # :mnesia.add_table_index(:users, :age)
    # :mnesia.index_read(:users, 30, :age)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # Dirty operations (fast, no transaction overhead)
  # -----------------------------------------------------------------------
  defp dirty_operations do
    IO.puts("--- Dirty Operations (no transaction, faster) ---")

    # dirty_write/1, dirty_read/2, dirty_delete/2
    # Use when you need speed and can tolerate weaker consistency
    # (e.g. counters, caches, telemetry)

    :mnesia.dirty_write({:users, 10, "Dave", "dave@example.com", 28})
    result = :mnesia.dirty_read(:users, 10)
    IO.puts("Dirty read: #{inspect(result)}")

    # dirty_update_counter — atomic increment (even without full transaction)
    # Requires the table to have a counter field as 3rd attribute
    # :mnesia.dirty_update_counter(:counters, :visits, 1)

    :mnesia.dirty_delete({:users, 10})
    IO.puts("After dirty delete: #{inspect(:mnesia.dirty_read(:users, 10))}")

    # dirty_match_object — pattern match without transaction
    all = :mnesia.dirty_match_object({:users, :_, :_, :_, :_})
    IO.puts("All users (dirty): #{inspect(all)}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # Table types
  # -----------------------------------------------------------------------
  defp table_types do
    IO.puts("--- Table Types ---")

    # :set (default) — unique key, one record per key
    # :bag           — same key allowed, but no two identical full records
    # :ordered_set   — like :set but ordered by key (uses B-tree)

    :mnesia.create_table(:tags, [
      attributes: [:article_id, :tag],
      type: :bag  # same article_id can have multiple tags
    ])

    :mnesia.transaction(fn ->
      :mnesia.write({:tags, 1, "elixir"})
      :mnesia.write({:tags, 1, "erlang"})  # same key, different record — allowed in :bag
      :mnesia.write({:tags, 1, "otp"})
      :mnesia.write({:tags, 2, "elixir"})
    end)

    {:atomic, article_1_tags} = :mnesia.transaction(fn ->
      :mnesia.read(:tags, 1)
    end)
    IO.puts("Tags for article 1: #{inspect(article_1_tags)}")

    IO.puts("""

    Table storage options:
      ram_copies:  [node()]  — in-memory only (fast, lost on restart)
      disc_copies: [node()]  — RAM + disk (fast reads, durable)
      disc_only_copies: [node()] — disk only (slow, but very large data)

    Replication:
      Add multiple nodes to ram_copies/disc_copies to replicate.
      Mnesia handles sync automatically when nodes connect.
    """)
  end

  # -----------------------------------------------------------------------
  # Helpers
  # -----------------------------------------------------------------------
  defp get_all_users do
    {:atomic, users} = :mnesia.transaction(fn ->
      :mnesia.match_object({:users, :_, :_, :_, :_})
    end)
    users
  end

  defp teardown do
    :mnesia.stop()
  end
end
