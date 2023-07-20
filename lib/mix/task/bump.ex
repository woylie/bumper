defmodule Mix.Tasks.Bump do
  @shortdoc "Bumps the version"
  @moduledoc """
  Bumps the version.

  ## Usage

      mix bump patch
      mix bump minor
      mix bump major
  """

  @valid_args ["major", "minor", "patch"]
  @changelog "CHANGELOG.md"
  @mix_file "mix.exs"
  @readme "README.md"

  use Mix.Task

  @impl Mix.Task
  def run([arg]) when arg in @valid_args do
    app = Keyword.fetch!(Mix.Project.config(), :app)
    new_version = bump_version(current_version!(), String.to_existing_atom(arg))
    update_file(@changelog, &update_changelog(&1, new_version))
    update_file(@mix_file, &update_mix_file(&1, new_version))
    update_file(@readme, &update_readme(&1, app, new_version))
  end

  def run(_) do
    IO.puts(@moduledoc)
  end

  defp current_version! do
    Mix.Project.config()
    |> Keyword.fetch!(:version)
    |> Version.parse!()
  end

  defp bump_version(%{major: major} = current_version, :major) do
    Version.to_string(%{current_version | major: major + 1, minor: 0, patch: 0})
  end

  defp bump_version(%{minor: minor} = current_version, :minor) do
    Version.to_string(%{current_version | minor: minor + 1, patch: 0})
  end

  defp bump_version(%{patch: patch} = current_version, :patch) do
    Version.to_string(%{current_version | patch: patch + 1})
  end

  defp update_changelog(changelog, new_version) do
    today = Date.to_iso8601(Date.utc_today())
    unreleased_header = "## Unreleased"
    new_header = "#{unreleased_header}\n\n## [#{new_version}] - #{today}"
    String.replace(changelog, unreleased_header, new_header)
  end

  defp update_mix_file(mix_file, new_version) do
    String.replace(
      mix_file,
      ~r/@version "[0-9.]+"/,
      ~s(@version "#{new_version}")
    )
  end

  defp update_readme(readme, app, new_version) do
    app = inspect(app)

    String.replace(
      readme,
      ~r/{#{Regex.escape(app)}, ".+"}/,
      ~s({#{app}, "~> #{new_version}"})
    )
  end

  defp update_file(file, fun) do
    new_content =
      file
      |> File.read!()
      |> fun.()

    File.write!(file, new_content)
  end
end
