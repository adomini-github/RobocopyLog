◆概要◆
Robocopyで出力されたログファイルの末尾に記載されている情報を切り取って、オブジェクト化するPowerShellモジュールです。英語版のログ、日本語版のログの2言語で実行テスト済みです。
Import-Module RobocopyLog.psm1してからご利用ください。または、$env:PSModulePathで表示されるディレクトリのいずれかに格納することでPowerShell起動時に自動でモジュールをインポートさせることが可能です。

◆コマンド形式◆
使えるコマンドは下記のとおりです。
Get-RobocopyLogSummary -path <path>
<path>にはRobocopyから出力されたログファイルのパスを指定してください。

◆戻り値◆
戻り値としてPowerShellのカスタムオブジェクトを返します。
例えば下記のようなコマンドを実行した場合、次のようなプロパティを利用できます。
$RCLog = Get-RobocopyLogSummary -path <path>

$RCLog.DirsTotal      コピー対象となったディレクトリの全件数（double型）
$RCLog.DirsCopied     コピー成功したディレクトリの件数（double型）
$RCLog.DirsSkipped    コピーをスキップしたディレクトリの件数（double型）
$RCLog.DirsMismatch   不一致となったディレクトリの件数（double型）
$RCLog.DirsFAILED     コピーに失敗したディレクトリの件数（double型）
$RCLog.DirsExtras     コピー先から削除されたディレクトリの件数（double型）
$RCLog.DirsArray      上記の配列。上から順に.DirsArray[0]~[5]でそれぞれ同じ値を参照できます。

同様に上記のDirsをFiles,Bytesに置き換えるとそれぞれファイルの件数、容量を参照できます。
他に次のプロパティを参照できます。
$RCLog.TimesTotal   すべての処理にかかった時間（TimeSpan型）
$RCLog.TimesCopied  コピーにかかった時間（TimeSpan型）
$RCLog.TimesFailed  失敗にかかった時間（TimeSpan型）
$RCLog.TimesExtras  コピー先から削除するのにかかった時間（TimeSpan型）
$RCLog.IsSkipped    スキップとなったディレクトリ、ファイルが1件でも存在する（Bool型（$true or $false））
$RCLog.IsMismatch   不一致となったディレクトリ、ファイルが1件でも存在する（Bool型（$true or $false））
$RCLog.IsFailed     失敗となったディレクトリ、ファイルが1件でも存在する（Bool型（$true or $false））
$RCLog.IsExtras     コピー先から削除となったディレクトリ、ファイルが1件でも存在する（Bool型（$true or $false））
$RCLog.Speed        平均データ転送スピード。単位はByte/sec（long型）

◆注意事項◆
モジュール内のソースコードは改造OKですが、改造したものをインターネットなどの世間一般に広く公開、もしくは広く参照可能な場所に保管する場合は下記連絡フォームに改造コードを公開することと、公開するURLなどの参照方法をご連絡いただければOKです。
モジュール内のコマンド（Get-RobocopyLogSummary）を使用したコードの公開に関しては特に制限事項はありません。
バグ報告、要望についても同じく下記連絡フォームからご連絡ください。ただし、その対応を確約するものではありません。

連絡フォーム
https://syanaise-soudan.com/contact/

あどみに
