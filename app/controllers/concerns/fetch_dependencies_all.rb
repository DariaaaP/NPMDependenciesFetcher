class FetchDependenciesAll
  include HTTParty
  base_uri 'https://registry.npmjs.org/'

  def self.fetch_dependencies(package_name, depth = 1)
    if depth > 2
      return []
    end

    response = get("/#{package_name}/latest")

    package_data = response.parsed_response
    dependencies = package_data['dependencies'] || {}
    filtered_dependencies = dependencies.keys.reject { |item| item.include?("@")}

    dependencies_data = filtered_dependencies.map do |name|
      {
        name => fetch_dependencies(name, depth + 1)
      }
    end

    dependencies_data
  end
end