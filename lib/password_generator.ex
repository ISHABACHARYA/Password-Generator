defmodule PasswordGenerator do
  @moduledoc """
   Generates the password based on provided options
   options for the password generator:
   options do
    %{
      "length" => "10",
       "symbols" => "false",
       "numbers" => "false",
       "uppercase" => "false",
       "lowercase" => "false"
    }
    available options are length, symbols, numbers, uppercase and lowercase
  """
    @allowed_options [:length, :symbols, :numbers, :uppercase, :lowercase]
  @doc """
  generates the password based on option provided
  """

  @spec generate(options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  def generate(options) do
    length = Map.has_key?(options, "length")
    validate_length(length, options)
  end

  @spec validate_length(has_length :: atom(), options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  defp validate_length(:false, _), do: {:error, "Please provide length of the password."}
  defp validate_length(:true, options) do
    number_list = Enum.map(8..32, & Integer.to_string(&1))
    length = options["length"]
    length = String.contains?(length,number_list)
    validate_length_is_integer(length,options)
  end


  @spec validate_length_is_integer(with_in_range :: atom(), options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  defp validate_length_is_integer(false,_error), do: {:error, "Length must be between 7 and 32"}
  defp validate_length_is_integer(true, options) do
    length = options["length"] |> String.trim() |> String.to_integer()
    option_without_length = Map.delete(options,"length")
    value = Map.values(option_without_length) |> Enum.all?(fn a -> String.to_atom(a) |> is_boolean() end)
    validate_option_values_for_boolean(value, length, option_without_length)
  end

  @spec validate_option_values_for_boolean(is_all_value_boolean :: boolean(), length :: integer(), options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  defp validate_option_values_for_boolean(false,_,_),do: {:error, "Option value must be boolean!"}
  defp validate_option_values_for_boolean(true,length, options) do
    options =included_options(options)
    invalid_options? = options |> Enum.any?(&(&1 not in @allowed_options))
    validate_options(invalid_options?, length, options)
  end

  @spec included_options(options :: map()) :: [atom()]
  defp included_options(options) do
   options |> Enum.map(fn {key, _value} -> key |> String.to_atom() end)
  end

  @spec validate_options(allowed_options_only :: boolean(), length :: integer(), options :: [atom()]) :: {:ok, bitstring()} | {:error, bitstring()}
  defp validate_options(true, _, _), do: {:error, "Only options allowed is numbers, uppercase, lowercase and symbols"}
  defp validate_options(false,length, options) do
    generate_strings(length, options)
  end

  @spec generate_strings(length :: integer(), options :: [atom()]) :: {:ok, bitstring()}
  defp generate_strings(length, options) do
  options |> generate_random_strings(length) |> get_result()
  end

  @spec generate_random_strings(options :: [atom()], length :: integer()) :: [bitstring()]
  defp generate_random_strings(options,length) do
    Enum.map(1..length, fn _ -> Enum.random(options)|> get() end)
  end

  @spec get(atom()) :: bitstring()
  defp get(:lowercase) do
    <<Enum.random(?a..?z)>>
  end
  defp get(:uppercase) do
    <<Enum.random(?A..?Z)>>
  end
  defp get(:symbols) do
    String.split("!@#$%^&*(){}:<>?|[]\~.,/?","",trim: true )
    |>Enum.map(&(&1))
    |>Enum.random()
    |>to_string()
  end
  defp get(:numbers) do
    <<Enum.random(1..9)>>
  end

  @spec get_result([bitstring()]) :: {:ok, bitstring()}
  defp get_result(string) do
   result= string |> Enum.shuffle() |> to_string()
   IO.inspect(result)
   {:ok, result}
    end
end
