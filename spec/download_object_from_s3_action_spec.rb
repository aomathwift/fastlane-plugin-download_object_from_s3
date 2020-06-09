describe Fastlane::Actions::DownloadObjectFromS3Action do
  describe 'when each parameter is missing' do
    it "raise an error if region was not given" do
      expect {
        Fastlane::FastFile.new.parse("lane :test do
          download_object_from_s3({
            access_key_id: 'access_key_id',
            secret_access_key: 'secret_access_key',
            })
        end").runner.execute(:test)
      }.to raise_error("No value found for 'region'")
    end

    it "raise an error if bucket was not given" do
      expect {
        Fastlane::FastFile.new.parse("lane :test do
          download_object_from_s3({
            access_key_id: 'access_key_id',
            secret_access_key: 'secret_access_key',
            region: 'region',
            })
        end").runner.execute(:test)
      }.to raise_error("Bucket is not found. Please check to input correct bucket name.")
    end

    it "raise an error if invalid bucket name was given" do
      expect {
        Fastlane::FastFile.new.parse("lane :test do
          download_object_from_s3({
            access_key_id: 'access_key_id',
            secret_access_key: 'secret_access_key',
            region: 'region',
            bucket: 'bucket',
            })
        end").runner.execute(:test)
      }.to raise_error("Object is not found. Please check to input correct object key.")
    end
  end
end
