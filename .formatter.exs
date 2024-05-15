[
  import_deps: [:phoenix],
  inputs:
    Enum.flat_map(
      ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
      &Path.wildcard(&1, match_dot: true)
    ) -- ["lib/graphql_api/accounts/user.ex", "lib/graphql_api/accounts/preference.ex"]
]
