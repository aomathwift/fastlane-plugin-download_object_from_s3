describe Fastlane::Actions::DownloadObjectFromS3Action do
  let(:bucket) { double('bucket') }
  let(:object) { double('object') }
  let(:content) { double('content') }
  let(:body) { double('body') }
  let(:file) { "Test Contents" }

  before do
    allow(body).to receive(:read).and_return(file)
    allow(content).to receive(:body).and_return(body)
    allow(object).to receive(:get).and_return(content)
    allow(bucket).to receive(:object).and_return(object)
    allow_any_instance_of(Aws::S3::Resource).to receive(:bucket).and_return(bucket)
  end

  it "work with output path" do
    Fastlane::FastFile.new.parse("lane :test do
      download_object_from_s3({
        access_key_id: 'access_key_id',
        secret_access_key: 'secret_access_key',
        region: 'region',
        bucket: 'bucket',
        object_key: 'object',
        output_path: 'test.txt'
        })
    end").runner.execute(:test)
  end

  it "work without output path" do
    Fastlane::FastFile.new.parse("lane :test do
      download_object_from_s3({
        access_key_id: 'access_key_id',
        secret_access_key: 'secret_access_key',
        region: 'region',
        bucket: 'bucket',
        object_key: 'object',
        })
    end").runner.execute(:test)
  end

  it "raise an error if region was not given" do
    expect do
      Fastlane::FastFile.new.parse("lane :test do
        download_object_from_s3({
          access_key_id: 'access_key_id',
          secret_access_key: 'secret_access_key',
          })
      end").runner.execute(:test)
    end.to raise_error("No value found for 'region'")
  end

  it "raise an error if bucket was not given" do
    expect do
      Fastlane::FastFile.new.parse("lane :test do
        download_object_from_s3({
          access_key_id: 'access_key_id',
          secret_access_key: 'secret_access_key',
          region: 'region',
          })
      end").runner.execute(:test)
    end.to raise_error("Bucket is not found. Please check to input correct bucket name.")
  end

  it "raise an error if invalid bucket name was given" do
    expect do
      Fastlane::FastFile.new.parse("lane :test do
        download_object_from_s3({
          access_key_id: 'access_key_id',
          secret_access_key: 'secret_access_key',
          region: 'region',
          bucket: 'bucket',
          })
      end").runner.execute(:test)
    end.to raise_error("Object is not found. Please check to input correct object key.")
  end
end
