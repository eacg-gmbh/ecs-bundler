# frozen_string_literal: true

module ECSBundler
  class BundlerScanner
    class << self
      def run
        project_specification = ProjectSpecification.new
        {
          project: ECSBundler.config[:project],
          module: project_specification.name,
          moduleId: "bundler:#{project_specification.name}",
          dependencies: [specification_to_h(project_specification)]
        }
      end

      private

      def specification_to_h(spec)
        {
          name: spec.name,
          key: "bundler:#{spec.name}",
          description: spec.description,
          private: true,
          licenses: spec.license ? [{ name: spec.license }] : [],
          homepageUrl: spec.homepage,
          repoUrl: RepositoryFinder.url(spec),
          versions: [spec.version.to_s].compact,
          dependencies: spec.runtime_dependencies.map { |dependency| specification_to_h(dependency.to_spec) }
        }
      end
    end
  end
end
