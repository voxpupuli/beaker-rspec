module BeakerRSpec
  module Matchers
    module Apply
      class ApplyMatcher
        # @param [Beaker::Host] host
        def initialize(host)
          @host = host
        end

        # @param [String, Pathname] manifest
        def matches?(manifest)
          file_path = copy_manifest(manifest)

          command = Beaker::PuppetCommand.new('apply', file_path, :'detailed-exitcodes' => nil)

          result = @host.exec(command, accept_all_exit_codes: true)
          unless result.exit_code_in?([0, 2])
            @error = "Expected to apply manifest"
            @result = result
            return false
          end

          if @idempotently
            result = @host.exec(command, accept_all_exit_codes: true)
            if result.exit_code != 0
              @error = "Expected to apply manifest idempotently"
              @result = result
              return false
            end
          end

          true
        ensure
          @host.rm_rf(file_path) if file_path && !file_path.empty?
        end

        def idempotently
          @idempotently = true
          self
        end

        def description
          desc = 'apply'
          desc += ' idempotently' if @idempotently
          desc
        end

        def failure_message
          message = [@error, @result.output]

          begin
            cmd = failure_context
          rescue NameError
            # Not specified
          else
            message << default.exec(Beaker::Command.new(cmd)).output
          end

          message.join("\n")
        end

        private

        # @param [String, Pathname] manifest
        def copy_manifest(manifest)
          file_path = @host.tmpfile(%(apply_manifest_#{Time.now.strftime("%H%M%S%L")}.pp))

          case manifest
          when String
            manifest
            Tempfile.create do |tempfile|
              tempfile.write(manifest)
              tempfile.flush
              @host.do_scp_to(tempfile.path, file_path, {})
            end
          when Pathname
            @host.do_scp_to(manifest.to_s, file_path, {})
          else
            raise ArgumentError, 'Unsupported type'
          end

          file_path
        end
      end

      def apply
        ApplyMatcher.new(default)
      end

      def apply_on(host)
        ApplyMatcher.new(host)
      end
    end
  end
end
