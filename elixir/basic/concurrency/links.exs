# The majority of times we spawn processes in Elixir, we spawn them as linked processes.
# When a process started with spawn/1 fails,
# it merely logged an error but the parent process is still running.

spawn(fn -> raise "oops" end) #PID<0.94.0>
# [error] Process #PID<0.94.00> raised an exception
# ** (RuntimeError) oops
#     (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6

# That's because processes are isolated.
# If we want the failure in one process
# to propagate to another one, we should link them.
# This can be done with spawn_link/1

spawn_link(fn -> raise "oops" end)
