describe Fastlane::Actions::DownloadObjectFromS3Action do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The download_object_from_s3 plugin is working!")

      Fastlane::Actions::DownloadObjectFromS3Action.run(nil)
    end
  end
end
