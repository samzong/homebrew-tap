require "fileutils"
require "minitest/autorun"
require "pathname"
require "tmpdir"
require "yaml"
require_relative "../scripts/lib/homebrew_tap/package_tools"

class PackageToolsTest < Minitest::Test
  def stub_client(releases)
    client = HomebrewTap::GitHubClient.new(token: nil)
    client.define_singleton_method(:request_json) { |_path| releases }
    client
  end

  def test_latest_release_skips_subartifact_tags_for_recall_and_rx
    recall_client = stub_client([
      { "tag_name" => "recall-r2-v0.1.2", "draft" => false, "prerelease" => false },
      { "tag_name" => "v0.7.0", "draft" => false, "prerelease" => false }
    ])
    assert_equal "v0.7.0", recall_client.latest_release("samzong/Recall")&.fetch("tag_name")

    rx_client = stub_client([
      { "tag_name" => "rx-agent-v0.2.0", "draft" => false, "prerelease" => false },
      { "tag_name" => "v0.2.1", "draft" => false, "prerelease" => false }
    ])
    assert_equal "v0.2.1", rx_client.latest_release("samzong/rx")&.fetch("tag_name")
  end

  def test_latest_release_enforces_prerelease_tag_rule_regardless_of_flag
    releases = [
      { "tag_name" => "v0.8.0-rc.1", "draft" => false, "prerelease" => false },
      { "tag_name" => "v0.7.0", "draft" => false, "prerelease" => false }
    ]
    client = stub_client(releases)

    assert_equal "v0.7.0", client.latest_release("samzong/Recall", allow_prerelease: false)&.fetch("tag_name")
    assert_equal "v0.8.0-rc.1", client.latest_release("samzong/Recall", allow_prerelease: true)&.fetch("tag_name")
  end

  def test_normalize_version_respects_custom_prefix
    assert_equal "1.2.3", HomebrewTap.normalize_version("pkg-v1.2.3", prefix: "pkg-v")
    assert_equal "1.2.3", HomebrewTap.normalize_version("v1.2.3", prefix: "pkg-v")
  end

  def test_manifest_validate_rejects_unregistered_formula_and_cask
    %w[Formula Casks].each do |dir|
      Dir.mktmpdir do |tmpdir|
        root = Pathname.new(tmpdir)
        FileUtils.mkdir_p(root.join("Formula"))
        FileUtils.mkdir_p(root.join("Casks"))
        FileUtils.mkdir_p(root.join("packages"))

        File.write(root.join("Formula/known.rb"), <<~RUBY)
          class Known < Formula
            version "1.0.0"
          end
        RUBY
        File.write(root.join("packages/manifest.yml"), YAML.dump(
          "packages" => {
            "known" => {
              "type" => "formula",
              "source_repo" => "samzong/known",
              "path" => "Formula/known.rb",
              "assets" => {
                "bin" => { "filename" => "known.tar.gz" }
              }
            }
          }
        ))

        manifest = HomebrewTap::Manifest.new(root.join("packages/manifest.yml"))
        manifest.validate!(root: root)

        File.write(root.join("#{dir}/unregistered.rb"), "class Unregistered; end\n")
        error = assert_raises(HomebrewTap::Error) { manifest.validate!(root: root) }
        assert_includes error.message, "#{dir}/unregistered.rb"
      end
    end
  end
end
