module Shoe
  module Tasks

    class Release < AbstractTask
      def active?
        spec.extend(VersionExtensions)

        spec.has_version_greater_than?('0.0.0') &&
          there_is_no_tag_for(version_tag(spec.version)) &&
          we_are_on_the_master_branch
      end

      def define
        desc "Release #{spec.full_name}"
        task :release do
          File.open("#{spec.name}.gemspec", 'w') do |stream|
            stream.write(spec.to_ruby)
          end

          sh "git add #{spec.name}.gemspec"
          sh "git commit -a -m 'Release #{spec.version}'"
          sh "git tag #{version_tag(spec.version)}"

          if there_is_no_tag_for('semver')
            $stderr.puts <<-END.gsub(/^ +/, '')
            ---------------------------------------------
            SEMANTIC VERSIONING WARNING

            It seems you don't yet have a 'semver' tag.

            Please read more about the emerging consensus
            around semantic versioning:

            http://semver.org/
            ---------------------------------------------
            END
          end

          if there_is_a_remote_called('origin')
            sh 'git push origin master'
            sh 'git push --tags origin'
          end

          sh "gem build #{spec.name}.gemspec"

          if Gem::CommandManager.instance.command_names.include?('push')
            sh "gem push #{spec.file_name}"
          else
            $stderr.puts <<-END.gsub(/^ +/, '')
            ---------------------------------------------
            GEMCUTTER WARNING

            It seems you don't have gemcutter installed.

            Please `gem install gemcutter` and
            `gem push #{spec.file_name}`
            if you would like to make a public release.
            ---------------------------------------------
            END
          end
        end
      end

      def update_spec
        spec.files += Rake::FileList['*.gemspec']
      end

      private

      module VersionExtensions
        def has_version_greater_than?(string)
          version > Gem::Version.new(string)
        end
      end

      def there_is_a_remote_called(name)
        `git remote`.to_a.include?("#{name}\n")
      end

      def there_is_no_tag_for(tag)
        !`git tag`.to_a.include?("#{tag}\n")
      end

      def version_tag(version)
        "v#{spec.version}"
      end

      def we_are_on_the_master_branch
        `git symbolic-ref HEAD`.strip == 'refs/heads/master'
      end
    end

  end
end