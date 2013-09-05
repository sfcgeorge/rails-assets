require "open3"

module Build
  module Utils
    def sh(cwd, *cmd)
      cmd = cmd.join(" ")
      Rails.logger.debug "Running shell command '#{cmd}' in #{cwd}"

      output = ""
      status = Open3.popen3(cmd, :chdir => cwd) do |stdin, stdout, stderr, thr|
        stdout.each do |line|
          output << line
          Rails.logger.info(line.chomp)
        end

        stderr.each do |line|
          output << line
          Rails.logger.warn(line.chomp)
        end

        thr.value
      end

      if status.success?
        output
      else
        raise BuildError.new("Command '#{cmd}' failed with exit code #{status.to_i}", :log => output)
      end
    end
  end
end