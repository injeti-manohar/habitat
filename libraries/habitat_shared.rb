#
# Copyright:: 2017-2018 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# li

module Habitat
  module Shared
    HAB_VERSION = '0.73.0'.freeze
    LINUX_LAUNCHER_VERSION = '9167'.freeze
    WINDOWS_LAUNCHER_VERSION = '8656'.freeze
    WINDOWS_SERVICE_VERSION = '0.3.1'.freeze

    def hab_version
      HAB_VERSION
    end

    def hab_launcher_version
      if platform_family?('windows')
        WINDOWS_LAUNCHER_VERSION
      else
        LINUX_LAUNCHER_VERSION
      end
    end

    def hab_windows_service_version
      WINDOWS_SERVICE_VERSION
    end

    def hab(*command)
      # Windows shell_out does not support arrays, so manually cleaning and joining
      hab_cmd = if platform_family?('windows')
                  (['hab'] + command).flatten.compact.join(' ')
                else
                  (['hab'] + command)
                end

      if Gem::Requirement.new('>= 14.3.20').satisfied_by?(Gem::Version.new(Chef::VERSION))
        shell_out!(hab_cmd)
      else
        shell_out_compact_timeout!(hab_cmd)
      end
    rescue Errno::ENOENT
      Chef::Log.fatal("'hab' binary not found, use the 'hab_install' resource to install it first")
      raise
    end
  end
end
