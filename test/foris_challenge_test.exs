defmodule ForisChallengeTest do
  use ExUnit.Case
  alias ForisChallenge

  setup do
    %{
      acc: %{
        "Isabella" => %{
          days_list: [],
          days_amount: 0,
          minutes: 0
        },
        "Juan" => %{
          days_list: ["1", "2"],
          days_amount: 2,
          minutes: 84
        },
        "Felipe" => %{
          days_list: ["3"],
          days_amount: 1,
          minutes: 25
        }
      },
      input: [
        "Student Isabella\n",
        "Student Juan\n",
        "Student Felipe\n",
        "Presence Juan 1 13:10 14:00 F102\n",
        "Presence Juan 2 15:20 15:54 F300\n",
        "Presence Felipe 3 11:00 11:25 R501"
      ]
    }
  end

  describe "&ForisChallenge.run_logic/1" do
    test "Should return report with name, total minutes and total days of each student", %{
      input: input
    } do
      # Arrange: function uses input from setup

      # Act:
      result = ForisChallenge.run_logic(input)

      # Assert:
      expected_string = """
      Juan: 84 minutes in 2 days
      Felipe: 25 minutes in 1 day
      Isabella: 0 minutes
      """

      # Mock multiline string brings \n at the end by default, so had to create variable and trim it
      assert result == String.trim(expected_string)
    end

    test "Should return accumulator with new student", %{acc: acc} do
      # Arrange:
      line = "Student Maria\n"

      # Act:
      result = ForisChallenge.process_line(line, acc)

      # Assert:
      assert %{"Maria" => student_info, "Isabella" => _, "Juan" => _, "Felipe" => _} = result
      assert length(student_info.days_list) == 0
      assert student_info.days_amount == 0
      assert student_info.minutes == 0
    end

    test "Should return multi-line string sorted in descending order", %{acc: acc} do
      # Arrange: function uses acc from setup

      # Act:
      result = ForisChallenge.build_result(acc)

      # Assert:
      list = String.split(result, "\n")
      assert length(list) == 3
      assert Enum.at(list, 0) == "Juan: 84 minutes in 2 days"
      assert Enum.at(list, 1) == "Felipe: 25 minutes in 1 day"
      assert Enum.at(list, 2) == "Isabella: 0 minutes"
    end
  end

  describe "&ForisChallenge.handle_command/2" do
    test "Should add a student with empty information to the accumulator", %{acc: acc} do
      # Arrange:
      command = ["Student", "Maria"]

      # Act:
      result = ForisChallenge.handle_command(command, acc)

      # Assert:
      assert %{"Maria" => student_info, "Isabella" => _, "Juan" => _, "Felipe" => _} = result
      assert length(student_info.days_list) == 0
      assert student_info.days_amount == 0
      assert student_info.minutes == 0
    end

    test "Should update a student on the accumulator with presence information", %{acc: acc} do
      # Arrange:
      command = ["Presence", "Isabella", "1", "14:00", "16:00", "R100"]

      # Act:
      result =
        ForisChallenge.handle_command(command, acc)

      # Assert:
      assert %{"Isabella" => student_info, "Juan" => _, "Felipe" => _} = result
      assert length(student_info.days_list) == 1
      assert student_info.days_amount == 1
      assert student_info.minutes == 120
    end

    test "Should not update a student on the accumulator if presence is less than 5 minutes", %{
      acc: acc
    } do
      # Arrange:
      command = ["Presence", "Juan", "2", "14:00", "14:04", "R100"]

      # Act:
      result =
        ForisChallenge.handle_command(command, acc)

      # Assert:
      assert %{"Isabella" => _, "Juan" => student_info, "Felipe" => _} = result
      assert length(student_info.days_list) == 2
      assert student_info.days_amount == 2
      assert student_info.minutes == 84
    end

    test "Should only update student minutes if second presence in the same day", %{
      acc: acc
    } do
      # Arrange:
      command = ["Presence", "Juan", "2", "14:00", "14:10", "R100"]

      # Act:
      result =
        ForisChallenge.handle_command(command, acc)

      # Assert:
      assert %{"Isabella" => _, "Juan" => student_info, "Felipe" => _} = result
      assert length(student_info.days_list) == 2
      assert student_info.days_amount == 2
      assert student_info.minutes == 94
    end

    test "Should return the time struct ~T[14:15:00]" do
      # Arrange:
      input = "14:15"

      # Act:
      result = ForisChallenge.define_time(input)

      # Assert:
      assert result == ~T[14:15:00]
    end
  end
end
