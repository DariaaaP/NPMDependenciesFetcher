class FetchDependenciesAll
  include HTTParty
  base_uri "https://registry.npmjs.org/"

  def self.fetch_dependencies(package_name, acc = [])
    response = get("/#{package_name}/latest")
    package_data = response.parsed_response
    dependencies = package_data["dependencies"] || {}
    filtered_dependencies = dependencies.keys.reject { |item| item.include?("@") }

    filtered_dependencies.map do |name|
      next if acc.include?(name)

      acc.push(name)
      fetch_dependencies(name, acc)
    end

    acc
  end
end
