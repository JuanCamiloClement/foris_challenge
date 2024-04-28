defmodule ForisChallenge do
  def run do
    IO.stream(:stdio, :line)
    |> Enum.reduce(%{}, &process_line(&1, &2))
    |> build_result
    |> IO.puts()
  end

  def process_line(line, acc) do
    line
    |> String.trim()
    |> String.split(" ")
    |> handle_command(acc)
  end

  def build_result(student_times) do
    student_times
    |> Enum.sort_by(fn {_k, v} -> v.minutes end, :desc)
    |> prepare_result
    |> String.trim()
  end

  def handle_command(["Student" | [name]], acc) do
    Map.put(acc, name, %{days_list: [], days_amount: 0, minutes: 0})
  end

  def handle_command(["Presence" | tail], acc) do
    [name, day, initial_detection, final_detection, classroom] = tail

    initial_data = %{
      name: name,
      day: day,
      initial_detection: define_time(initial_detection),
      final_detection: define_time(final_detection),
      classroom: classroom
    }

    total_minutes =
      Time.diff(initial_data.final_detection, initial_data.initial_detection, :minute)

    if total_minutes > 5 do
      data = Map.put(initial_data, :total_minutes, total_minutes)

      student = Map.get(acc, data.name)

      updated_info =
        if Enum.any?(student.days_list, &(&1 == data.day)) do
          Map.put(student, :minutes, student.minutes + data.total_minutes)
        else
          student
          |> Map.put(:days_list, [data.day | student.days_list])
          |> Map.put(:days_amount, student.days_amount + 1)
          |> Map.put(:minutes, student.minutes + data.total_minutes)
        end

      Map.put(acc, data.name, updated_info)
    else
      acc
    end
  end

  def define_time(hour) do
    [hour, minutes] =
      hour
      |> String.split(":")
      |> Enum.map(&String.to_integer(&1))

    {:ok, time} = Time.new(hour, minutes, 0)

    time
  end

  def prepare_result(sorted_data) do
    Enum.reduce(sorted_data, "", fn element, acc ->
      {name, info} = element

      cond do
        info.days_amount == 0 ->
          acc <> "#{name}: #{info.minutes} minutes\n"

        info.days_amount > 0 ->
          acc <>
            "#{name}: #{info.minutes} minutes in #{info.days_amount} #{if info.days_amount > 1, do: "days", else: "day"}\n"
      end
    end)
  end
end
