require 'fastlane/action'
require_relative '../helper/download_object_from_s3_helper'
require 'aws-sdk'
require 'fileutils'

module Fastlane
  module Actions
    class DownloadObjectFromS3Action < Action
      def self.run(params)
        UI.message("Downloading from AWS S3...")
        credentials = Aws::Credentials.new(
          access_key_id = params[:access_key_id],
          secret_access_key = params[:secret_access_key]
        )

        s3_resource = Aws::S3::Resource.new(
          credentials: credentials,
          region: params[:region]
        )

        begin
          bucket = s3_resource.bucket(params[:bucket])
        rescue => exception
          UI.user_error!("Bucket is not found. Please check to input correct bucket name.")
        end

        begin
          object = bucket.object(params[:object_key])
        rescue
          UI.user_error!("Object is not found. Please check to input correct object key.")
        end

        if params[:output_path]
          file_path = "./#{File.dirname(params[:output_path])}"
          file_name = File.basename(params[:output_path])
        else
          file_path = "."
          file_name = params[:object_key].split("/").last
        end
        

        unless File.exist?(file_path)
          FileUtils.mkdir_p(file_path)
        end

        FileUtils.cd(file_path)
        File.open(file_name, "w+") do |file|
          file.puts(object.get.body.read)
        end

        UI.success("The file is successfully downloaded from AWS S3 📥")
      end

      def self.description
        "Download objects from AWS S3"
      end

      def self.authors
        ["aomathwift"]
      end

      def self.details
        "With download_object_from_s3 action, you can download various objects such as images, IPAs, APKs from AWS S3. This is useful, for example, when you want to share artifacts between separated CI jobs."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :access_key_id,
                                  env_name: "AWS_ACCESS_KEY_ID",
                               description: "AWS Access key",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :secret_access_key,
                                  env_name: "AWS_SECRET_ACCESS_KEY",
                               description: "AWS Secret Access key",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :region,
                                  env_name: "AWS_REGION",
                               description: "AWS S3 Region",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :bucket,
                                  env_name: "S3_BUCKET",
                               description: "AWS S3 Bucket name",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :object_key,
                                  env_name: "S3_OBJECT_KEY",
                               description: "AWS S3 Object key",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :output_path,
                                  env_name: "OUTPUT_PATH",
                               description: "S3 Object Output Path",
                                  optional: true,
                                      type: String),
          
        ]
      end

      def self.is_supported?(platform)
        platform == :ios || platform == :android
      end
    end
  end
end
