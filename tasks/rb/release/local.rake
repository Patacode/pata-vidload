namespace "rb:release" do
  desc 'Release current gem version to local'
  task :gem_release_local do
    sh './scripts/release-local.sh'
  end
end
