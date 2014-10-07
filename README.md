# Git::Flow::Extension

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git-flow-extension'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-flow-extension

## Usage

# Git-Flow Extension

Git-Flow ExtensionはGithubを利用したGit-Flowの利用を簡単にするためのツールです。

## 使い方

In-Ruby

```
gfx = GitFlowExtension.new(:user, :repo, :token)
gfx.release.create revision
gfx.release.start revision
gfx.release.update revision
gfx.release.finish revision

gfx.hotfix.create revision
gfx.hotfix.start revision
gfx.hotfix.update revision
gfx.hotfix.finish revision
```

or

Command-Line

```
$ cat .gfx

---
user: user
repo: repo
token: token

$ gfx release create revision
$ gfx release start  revision
$ gfx release update revision
$ gfx release finish revision

$ gfx hotfix create revision
$ gfx hotfix start  revision
$ gfx hotfix update revision
$ gfx hotfix finish revision
```


## リリース

1. イシューを作成する [create]
2. リリースブランチを作る [start]
3. イシューからプルリクエストを作る (from release/ to master) [start]
4. リリース用の修正作業を行う
5. プルリクエストをマージする [finish]
6. masterでタグを打つ [finish]
7. release/#{revision} を develop にマージする

## ホットフィックス

1. hotfix/#{revision} のブランチを作成する
2. イシューを作成する
3. hotfix/#{revision} を閉じる
4. イシューからプルリクエストを作る (from hotfix/ to master)
5. リリース用の修正作業を行う
6. プルリクエストをマージする
7. masterでタグを打つ
8. hotfix/#{revision} を develop にマージする

イシューのフォーマット
-------------------

Title: ```Release v#{revision}``` or ```Hotfix v#{revision}```

Body:

```
base: master
head: release/v10
tag: v0.0.1

リリースノート
----

ここに変更点のリリースノートを最後に記入する

マージ済みの修正
----

- [x] [テストされてマージされた修正](https://github.com/sumipan/git-flow-extension.rb/pull/1)
- [ ] [テストされていないがマージされた修正](https://github.com/sumipan/git-flow-extension.rb/pull/2)


マージされていない修正
----

- [x] [テストされて、まだマージされていない修正](https://github.com/sumipan/git-flow-extension.rb/pull/3)
- [ ] [テストされていなく、まだマージされていない修正](https://github.com/sumipan/git-flow-extension.rb/pull/4)
```
- [ ] [Don't merge! 実機確認用です](https://github.com/kayac/kuwata-unity/pull/5401)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/git-flow-extension/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
