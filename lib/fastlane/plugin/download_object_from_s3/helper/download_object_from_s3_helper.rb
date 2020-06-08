require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class DownloadObjectFromS3Helper
      # class methods that you define here become available in your action
      # as `Helper::DownloadObjectFromS3Helper.your_method`
      #
      def self.show_message
        UI.message("Hello from the download_object_from_s3 plugin helper!")
      end
    end
  end
end
