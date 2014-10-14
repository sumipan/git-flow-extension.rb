# Git::Flow::Extension

Inspire from motemen/git-pr-release. git-flow on the Github. Support command-line base operation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git-flow-extension'
```

And then execute:

    $ bundle

## 使い方

in ruby

```
require 'git_flow_extension'

gfx = GitFlowExtension::Client.new
gfx.release.create :revision => 100
gfx.release.start  :number => 5001
gfx.release.update :number => 5001
gfx.release.finish :number => 5001

gfx.hotfix.create :revision => 101
gfx.hotfix.start  :number => 5002
gfx.hotfix.update :number => 5002
gfx.hotfix.finish :number => 5002
```

or

Command-Line

```
gfx release create --revision=100 --head=develop --base=release/100 --tag=v1.0.0
gfx release update --number=5001
gfx release start --number=5001
gfx release finish --number=5001
```

## hook point

```
gfx.release.on('create:before') do |opts|
  # フックしたい処理をここに入れる
end
```

フックポイントの種類

- create:before
- create:after
- create:error
- start:before
- start:after
- start:error
- update:before
- update:after
- update:error
- finish:before
- finish:after
- finish:error


### create

新しいリリースのための管理用のイシューを作成します。

イシューのフォーマットはヘッダーまではテンプレートから作成されますが、
そこより下の部分はプログラムから自動で生成されます。

含まれる情報は以下の通りです。

- head ブランチの指定
- base ブランチの指定
- リリース時に自動的に tag を打つ場合は tag を指定


### start

リリース管理用のイシューからリリースブランチを作成します。
リリース感利用のイシューがそのままプルリクエストに変更されます。
baseブランチとheadブランチの間に差分がない場合はエラーになります。

### update

head ブランチへのマージ履歴を元にイシューを更新します。
head ブランチに送られたプルリクエストをイシューに記載します。

### finish

base ブランチへ head ブランチをマージします。
マージした後のフック処理を呼び出します。


## イシューのフォーマット

Title: ```Release v#{revision}``` or ```Hotfix v#{revision}```

Body:

```

リリースノート
----

ここに変更点のリリースノートを最後に記入する

----

base: master
head: release/v10
tag: v0.0.1

マージ済みの修正
----

- [x] [テストされてマージされた修正](https://github.com/sumipan/git-flow-extension.rb/pull/1)
- [ ] [テストされていないがマージされた修正](https://github.com/sumipan/git-flow-extension.rb/pull/2)


マージされていない修正
----

- [x] [テストされて、まだマージされていない修正](https://github.com/sumipan/git-flow-extension.rb/pull/3)
- [ ] [テストされていなく、まだマージされていない修正](https://github.com/sumipan/git-flow-extension.rb/pull/4)

クローズされた修正
----

- [ ] <del>[Don't merge! 実機確認用です](https://github.com/kayac/kuwata-unity/pull/5401)</del>

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/git-flow-extension/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
