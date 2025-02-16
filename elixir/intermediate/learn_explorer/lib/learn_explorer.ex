defmodule LearnExplorer do
  require Explorer.DataFrame, as: DF
  require Explorer.Datasets, as: DS
  alias Explorer.Series


  def run do
    # We can use the sample dataset
    # from `Explorer.Datasets` or create our own.

    IO.puts("\n=== Iris Dataset ===")
    IO.inspect(DS.iris())

    IO.puts("\n=== Wine Dataset ===")
    IO.inspect(DS.wine())

    IO.puts("\n=== CO2 emissions from fossil fuels since 2010, by country ===")
    IO.inspect(DS.fossil_fuels())

    # Create initial DataFrame
    df = DF.new(%{
      name: ["John", "Jane", "Bob", "Alice", "Mike", "Sarah", "Tom"],
      age: [25, 30, 35, 28, 32, 35, 28],
      salary: [50000, 60000, 75000, 55000, 62000, 78000, 54000],
      department: ["IT", "HR", "IT", "Finance", "HR", "IT", "Finance"]
    })

    IO.puts("\n=== Original DataFrame ===")
    IO.inspect(df)
    DF.print(df) # this will print the dataframe as table

    # Basic operations
    avg_salary = df["salary"] |> Series.mean()
    IO.puts("\n=== Average Salary ===")
    IO.inspect(avg_salary)

    # Filter DataFrame
    high_earners = DF.filter(df, salary > mean(salary))
    IO.puts("\n=== High Earners (>60000) ===")
    IO.inspect(high_earners)

    # Sort by age
    sorted_df = DF.sort_by(df, asc: age)
    IO.puts("\n=== Sorted by Age ===")
    IO.inspect(sorted_df)

    # Add a new column for bonus (10% of salary)
    df_with_bonus = DF.mutate(df, bonus: salary * 0.1)
    IO.puts("\n=== DataFrame with Bonus Column ===")
    IO.inspect(df_with_bonus)

    # Group By Operations
    # 1. Basic department statistics
    dept_stats = df
    |> DF.group_by("department")
    |> DF.summarise(
      avg_salary: Series.mean(salary),
      employee_count: Series.count(salary),
      min_age: Series.min(age),
      max_age: Series.max(age)
    )
    IO.puts("\n=== Department Statistics ===")
    IO.inspect(dept_stats)

    # 2. Age groups with salary analysis
    age_categories = fn
      x when x < 30 -> "Junior"
      x when x < 35 -> "Mid"
      _ -> "Senior"
    end

    df_age_groups = df
    |> DF.put(:age_group, Series.transform(DF.pull(df, "age"), age_categories))
    |> DF.group_by("age_group")
    |> IO.inspect()
    |> DF.summarise(
      avg_salary: Series.mean(salary),
      count: Series.count(salary)
    )
    IO.puts("\n=== Salary by Age Group ===")
    IO.inspect(df_age_groups)

    # 3. Complex grouping with multiple dimensions
    salary_categories = fn
      x when x < 55000 -> "Low"
      x when x < 70000 -> "Medium"
      _ -> "High"
    end

    complex_analysis = df
    |> DF.put(:salary_tier, Series.transform(DF.pull(df, "salary"), salary_categories))
    |> DF.group_by(["department", "salary_tier"])
    |> DF.summarise(
      employee_count: Series.count(salary),
      avg_age: Series.mean(age)
    )
    |> DF.sort_by(desc: employee_count)

    IO.puts("\n=== Complex Analysis by Department and Salary Tier ===")
    IO.inspect(complex_analysis)
  end
end
