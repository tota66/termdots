termdots
========

ターミナルでドット絵を表示させる

## 使い方
rubyで作成しているため、rubyの実行環境が必要です。  
また、RMagickモジュールが必要です。  

* RMagickインストール方法例  
```
$ sudo yum install ImageMagick ImageMagick-devel  
$ sudo gem install rmagick  
```

* 実行  
第1引数に画像のパスを指定。画像の形式はgif/jpg/png/bmpなど可。  
```
$ ruby termdots.rb path/to/imagefile  
```

* 色数モード  
16色と256色の表示モードがあります。  
コード内のCOLOR_MODEの値を変更することでモード変更が可能。  

