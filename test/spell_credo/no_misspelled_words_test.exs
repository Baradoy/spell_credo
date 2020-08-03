defmodule SpellCredo.NoMisspelledWordsTest do
  use Credo.Test.Case

  alias SpellCredo.NoMisspelledWords

  @default_params [language_code: "en_CA", user_dictionary: nil]

  test "Accepts correctly spelled words" do
    """
    @moduledoc "Information about the module goes here"

    defmodule CredoTestModule do
      def spelled_correctly(something, something_else) do
        something <> something_else <> "real string here"
      end
    end
    """
    |> to_source_file()
    |> run_check(NoMisspelledWords, @default_params)
    |> refute_issues()
  end

  test "Rejects incorrectly spelt words" do
    """
    @moduledoc "Information about the module goes here

    Is inexorablabiliabuddy a proper word?
    "

    defmodule CredoTestModule do
      def spelled_correctly(something, something_else) do
        something <> something_else <> "real string here"
      end
    end
    """
    |> to_source_file()
    |> run_check(NoMisspelledWords, @default_params)
    |> assert_issue(fn issue -> assert issue.trigger == "inexorablabiliabuddy" end)
  end

  test "Uses user_dictionary to accept words" do
    """
    @moduledoc "Information about the module goes here

    Is inexorablabiliabuddy a proper word?
    "

    defmodule CredoTestModule do
      def spelled_correctly(something, something_else) do
        something <> something_else <> "real string here"
      end
    end
    """
    |> to_source_file()
    |> run_check(NoMisspelledWords,
      language_code: "en_CA",
      user_dictionary: "test/user_test_dictionary.list"
    )
    |> refute_issues()
  end
end
