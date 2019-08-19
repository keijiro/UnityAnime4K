UnityAnime4K
============

[Anime4K] is a high-quality and fast image upscaler that is specialized for
anime style images. This repository contains an implementation of Anime4K in
Unity that can be used for upscaling low resolution textures to higher ones.

[Anime4K]: https://github.com/bloc97/Anime4K

Examples
--------

![Bilinear](https://i.imgur.com/fGhT37o.png)
![Anime4K](https://i.imgur.com/gbgO42S.png)

(Left: Bilinear, Right: Anime4K)

![Bilinear](https://i.imgur.com/8zAh73j.png)
![Anime4K](https://i.imgur.com/VvoNqIs.png)

(Left: Bilinear, Right: Anime4K)

![Bilinear](https://i.imgur.com/MQWXz7s.png)
![Anime4K](https://i.imgur.com/Z0BA4nF.png)

(Left: Bilinear, Right: Anime4K)

How To Use
----------

There is only single static method in the namespace:

`Anime4K.ImageFilter.Upscale(source, destination, push)`

You can give any texture to `source`. An upscaled result will be stored in a
render texture given in `destination`.

The `push` parameter controls the strength of the sharpen effect with a value
between 0 (weak) to 1 (strong). In most cases, it's okay to just set 1; Decrese
it when the effect is noticeably too strong.

Acknowledgements
----------------

This repository contains the following image materials:

- 【物語×放置ゲームコレクション】ゴスロリ吸血鬼 from Niconi Commons

  https://commons.nicovideo.jp/material/nc160359

- ジュエルセイバーFREE

  http://www.jewel-s.jp/

License
-------

I (Keijiro Takahashi) waive all rights to the additions/modifications to the
original Anime4K code. Please follow the [original license] when using the code
in your project.

[original license]: https://github.com/bloc97/Anime4K/blob/master/LICENSE
