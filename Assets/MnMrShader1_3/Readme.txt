【まんまるしぇーだー_ver_1.3】

☆概要☆
まんまるしぇーだーはMatcapによる光源の影響を受けない陰影が特徴のシェーダーです。

～verUP内容～
standardShaderに一部の変数名を合わせました。（standard化への対策
Outlineの色をテクスチャーで指定できるようになりました。

☆マニュアル☆

Cull Mode
　両面表示、片面表示、を切り替えます。Outlineは両面表示で固定です。
　OFF　　両面表示
　FRONT　片面表示（裏面のみ
　BACK   片面表示（表面のみ

Color(元BassColor)	
　基本となる色を指定します。「MainTex」に乗算されます。

MainTex(元BassTex)
　基本となる色を指定するテクスチャーです。「Color」に乗算されます。
　使用したいモデルのテクスチャーを割り当てます。

NormalTex
　ノーマルマップを割り当てます。


ShadowMatcapColor
　「ShadowMatcapTex」の色を調整します。「ShadowMatcapTex」にオーバーレイされます。

ShadowMatcapTex
　陰影用のMatcapです。「ShadowMatcapColor」がオーバーレイされたあと、「BassColor」に乗算されます。

ShadowMatcapMaskTex
　陰影に対するマスクテクスチャーです。グレースケールで指定します。白い近いほどマスクされ、黒に近いほど影が落ちます。
　☆陰影部にスクリーンで合成して陰影を飛ばす仕様なのでカラーのテクスチャを割り当てることで影に色味を与えることも出来ます


LightMatcapColor
　「LightMatcapTex」の色を調整します。「LightMatcapTex」に乗算されます。明暗で強度調整ができます。

LightMatcapTex
　光沢用のMatcapです。「LightMatcapColor」が乗算されたあと、「BassColor」にスクリーンされます。

LightMatcapMaskTex
　光沢に対するマスクテクスチャーです。グレースケールで指定します。白い近いほどマスクされ、黒い近いほど光沢が出ます。


LightMatcapColor2
　「LightMatcapTex2」の色を調整します。「LightMatcapTex」に乗算されます。明暗で強度調整ができます。

LightMatcapTex2
　光沢用のMatcapです。「LightMatcapColor2」が乗算されたあと、「BassColor」にスクリーンされます。
　主にリムライト効果等を想定しています。こちらにはマスク機能はありません。


Outline_Color（～Outlineのみ）
　アウトラインの色を指定します。

Outline_Tex（～Outlineのみ）
　アウトラインの色を指定するテクスチャです。Outline_Colorに乗算されます。

Outline_Wigth（～Outlineのみ）
　アウトラインの幅をしています。

Outline_Mask（～Outlineのみ）
　アウトラインに対するマスクテクスチャーです。グレースケールで指定します。白い近いほどマスクされ、黒い近いほどアウトラインがでます。


EmissionPower
　Emissionの強度です。（光源を無視したアンリットのような表示になっていきます

EmissionMap
　Emissionの範囲と強度を指定するテクスチャーです。グレースケールで指定します。白い近いほど強く、黒い近いほど弱くかかります。


Clipping（～Clippingのみ）
　クリッピングの境界を微調整します。



☆ライセンス☆
MITライセンスです。
商用利用ok、再配布ok、改造okです。