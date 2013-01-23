root = text

text = text:(text_tags / tags / any)+ { return peg_flatten(text).join(''); }

text_tags = imag / multicols / center / left / right / justify / serif
imag    = bra '絵' num:num ket newline? { return '<div class="imag"><div class="imag_test">' + num + '</div></div>' + "\n"; }
multicols = multicols_2 / multicols_3
multicols_2 = bra m [2２] ket newline? inner:(align align)       { return '<div class="multicols_2">' + peg_flatten(inner).join('') + '</div>' + "\n"; }
multicols_3 = bra m [3３]? ket newline? inner:(align align align) { return '<div class="multicols_3">' + peg_flatten(inner).join('') + '</div>' + "\n"; }
align = left / center / right
center  = bra c ket newline? inner:(!text_tags (tags / any))+ { return '<div class="align_center">'   + peg_flatten(inner).join('') + '</div>' + "\n"; }
left    = bra l ket newline? inner:(!text_tags (tags / any))+ { return '<div class="align_left">'     + peg_flatten(inner).join('') + '</div>' + "\n"; }
right   = bra r ket newline? inner:(!text_tags (tags / any))+ { return '<div class="align_right">'    + peg_flatten(inner).join('') + '</div>' + "\n"; }
justify = bra j ket newline? inner:(!text_tags (tags / any))+ { return '<div class="align_justify">'  + peg_flatten(inner).join('') + '</div>' + "\n"; }

serif = &(icon_l / icon_r) message newline?

messages = messages:(message newline? serif+ / message) { return peg_flatten(messages).join(''); }
message = icon:icon speaker:speaker balloon:balloon newline? message:(!text_tags (tags / any))+ {
  if(icon[0]=='l') {
    return '<div class="serif left"><div class="icon"><div class="icon_test">'  + icon[1] + '</div>' + speaker + '</div>' + '<div class="balloon' + balloon + '">' + peg_flatten(message).join('') + '</div></div>' + "\n";
  }else{
    return '<div class="serif right"><div class="icon"><div class="icon_test">' + icon[1] + '</div>' + speaker + '</div>' + '<div class="balloon' + balloon + '">' + peg_flatten(message).join('') + '</div></div>' + "\n";
  }
}

icon    = icon_l / icon_r / '' { return ['l',   0]; }
icon_l  = bra l? num:num ket   { return ['l', num]; }
icon_r  = bra r  num:num ket   { return ['r', num]; }
speaker = bra speaker:(!ket any)+ ket { return peg_flatten(speaker).join(''); } / '' { return '愛称'; }
balloon = bra balloon:[考無] ket {
  var ba = {
    '考' : ' think',
    '無' : ' no'
  }
  return ba[balloon];
} / ''

tags    = self / target / newline / bold / italic / delete / under / big / small / ruby / font_color / normal_tag
self    = bra '自分' ket { return '「自分の愛称」'; }
target  = bra '対象' ket { return '「対象の愛称」'; }
newline = [\n\r] { return '<br>'; }
bold   =   bold_tag inner:(!(text_tags / normal_tag /   bold_tag) (tags / any))+   bold_tag? &normal_tag? { return '<b>'     + peg_flatten(inner).join('') +     '</b>'; }
italic = italic_tag inner:(!(text_tags / normal_tag / italic_tag) (tags / any))+ italic_tag? &normal_tag? { return '<i>'     + peg_flatten(inner).join('') +     '</i>'; }
delete = delete_tag inner:(!(text_tags / normal_tag / delete_tag) (tags / any))+ delete_tag? &normal_tag? { return '<del>'   + peg_flatten(inner).join('') +   '</del>'; }
under  =  under_tag inner:(!(text_tags / normal_tag /  under_tag) (tags / any))+  under_tag? &normal_tag? { return '<u>'     + peg_flatten(inner).join('') +     '</u>'; }
big    =    big_tag inner:(!(text_tags / normal_tag)              (tags / any))+             &normal_tag? { return '<big>'   + peg_flatten(inner).join('') +   '</big>'; }
small  =  small_tag inner:(!(text_tags / normal_tag)              (tags / any))+             &normal_tag? { return '<small>' + peg_flatten(inner).join('') + '</small>'; }
ruby = bra rb:(!(text_tags / ruby / ket) (tags / any))+ ket ('^' / '＾') bra rt:(!(text_tags / ruby / ket) (tags / any))+ ket {
  return '<span class="ruby"><span class="rb">' + peg_flatten(rb).join('') + '</span><span class="rp">(</span><span class="rt">' + peg_flatten(rt).join('') + '</span><span class="rp">)</span></span>';
}
font_color =  font_color1 / font_color2 / font_color3 / font_color4 / font_color5 / font_color6 / font_color7
font_color1 = font_color1_tag inner:(!(text_tags / normal_tag / font_color_tag) (tags / any))+ font_color1_tag? &normal_tag? { return '<font color="#FF0000">' + peg_flatten(inner).join('') + '</font>'; }
font_color2 = font_color2_tag inner:(!(text_tags / normal_tag / font_color_tag) (tags / any))+ font_color2_tag? &normal_tag? { return '<font color="#FFA500">' + peg_flatten(inner).join('') + '</font>'; }
font_color3 = font_color3_tag inner:(!(text_tags / normal_tag / font_color_tag) (tags / any))+ font_color3_tag? &normal_tag? { return '<font color="#FFFF00">' + peg_flatten(inner).join('') + '</font>'; }
font_color4 = font_color4_tag inner:(!(text_tags / normal_tag / font_color_tag) (tags / any))+ font_color4_tag? &normal_tag? { return '<font color="#00FF00">' + peg_flatten(inner).join('') + '</font>'; }
font_color5 = font_color5_tag inner:(!(text_tags / normal_tag / font_color_tag) (tags / any))+ font_color5_tag? &normal_tag? { return '<font color="#0000FF">' + peg_flatten(inner).join('') + '</font>'; }
font_color6 = font_color6_tag inner:(!(text_tags / normal_tag / font_color_tag) (tags / any))+ font_color6_tag? &normal_tag? { return '<font color="#000080">' + peg_flatten(inner).join('') + '</font>'; }
font_color7 = font_color7_tag inner:(!(text_tags / normal_tag / font_color_tag) (tags / any))+ font_color7_tag? &normal_tag? { return '<font color="#800080">' + peg_flatten(inner).join('') + '</font>'; }

  bold_tag = bra b ket
italic_tag = bra i ket
delete_tag = bra d ket
 under_tag = bra u ket
 small_tag = bra s ket
   big_tag = bra bg ket

font_color_tag = font_color1_tag / font_color2_tag / font_color3_tag / font_color4_tag / font_color5_tag / font_color6_tag / font_color7_tag
font_color1_tag = bra [赤] ket
font_color2_tag = bra [橙] ket
font_color3_tag = bra [黄] ket
font_color4_tag = bra [緑] ket
font_color5_tag = bra [青] ket
font_color6_tag = bra [藍] ket
font_color7_tag = bra [紫] ket
normal_tag = bra n ket { return ''; }

num = num:(n1_9 n0_9+ / n0_9) { return peg_cast_num(peg_flatten(num).join("")); }

bra = [<＜]
ket = [>＞]
n1_9  = [1-9１-９]
n0_9  = [0-9０-９]
m = [mMｍＭ複]
l = [lLｌＬ左]
r = [rRｒＲ右]
c = [cCｃＣ中]
j = [jJｊＪ均]
b = [bBｂＢ太]
i = [iIｉＩ斜]
d = [dDｄＤ消]
u = [uUｕＵ下]
s = [sSｓＳ小]
bg = [大]
n = [nNｎＮ元]
any = any:. {
  any  = any.replace(/</, '&lt;');
  return any.replace(/>/, '&gt;');
}
