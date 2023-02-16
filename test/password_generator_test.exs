defmodule PasswordGeneratorTest do
  use ExUnit.Case

  setup  do
    options= %{
       "length" => "10",
       "symbols" => "false",
       "numbers" => "false",
       "uppercase" => "false",
       "lowercase" => "false"
    }
    options_type = %{
       symbols: String.split("!@#$%^&*(){}:<>?|[]\~.,/?","",trim: true ),
       numbers: Enum.map(0..9, & Integer.to_string(&1)),
       uppercase: Enum.map(?A..?Z, & <<&1>> ),
       lowercase: Enum.map(?a..?z, & <<&1>>),
    }
    {:ok, result}  = PasswordGenerator.generate(options)
    IO.puts('test --- setup')
    %{options_type: options_type, result: result}
  end

  test "generates a string",%{result: result} do
      assert is_bitstring(result)
  end

  test "returns an error when password length is not given" do
    options = %{invalid: "false"}
    assert {:error, _err} = PasswordGenerator.generate(options)
  end

  test "returns an error when password length is not an integer" do
    options = %{"length" =>"ab"}
    assert {:error, _err} = PasswordGenerator.generate(options)
  end

  test "options length matches the generated password length", %{result: result} do
    assert 10 = String.length(result)
  end

  test "options passed are boolean other than length" do
    options = %{"length" => "10", "lowercase" => "random", "symbols" => "random"}
    assert {:error, _err} = PasswordGenerator.generate(options)
  end
end
