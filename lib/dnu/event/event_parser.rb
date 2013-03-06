# encoding: UTF-8
class EventParser < Parslet::Parser
  
  # single character rules
  
  rule(:spaces?) {
    match('[ \t　]').repeat(1).maybe
  }
  
  rule(:newline) {
    match('[\r\n]').repeat(1)
  }
  
  rule(:num_1_to_9) {
    match('[1-9１-９]')
  }
  
  rule(:num_0_to_9) {
    match('[0-9０-９]')
  }
  
  rule(:color) {
    match('[0-9a-fA-F０-９ａ-ｆＡ-Ｆ]').repeat(6,6)
  }
  
  rule(:bra) {
    spaces? >> match('[(\[{（［｛「【]') >> spaces?
  }
  
  rule(:ket) {
    spaces? >> match('[)\]}）］｝」】]') >> spaces?
  }
  
  rule(:separator) {
    spaces? >> match('[|:/｜：／・]') >> spaces?
  }
  
  rule(:partition) {
    match('[-]').repeat(1) >> newline
  }
  
  rule(:from_to) {
    match('[-~‐－―ー～]') | str('から')
  }
  
  rule(:dot) {
    match('[.．]')
  }
  
  rule(:plus) {
    spaces? >> match('[+＋]') >> spaces?
  }
  
  rule(:minus) {
    spaces? >> match('[-－]') >> spaces?
  }
  
  rule(:multiply) {
    spaces? >> match('[*xX＊ｘＸ×]') >> spaces?
  }
  
  rule(:percent) {
    match('[%％]')
  }
  
  rule(:arrow) {
    spaces? >> (
      match('[→⇒]') |
      match('[=＝]') >> match('[>＞]')
    ) >> spaces?
  }
  
  rule(:op_ge) {
    match('[≧]') |
    match('[>＞]') >> match('[=＝]')
  }
  
  rule(:op_le) {
    match('[≦]') |
    match('[<＜]') >> match('[=＝]')
  }
  
  rule(:op_eq) {
    match('[=＝]')
  }
  
  rule(:op_and) {
    str('かつ') | str('に') | str('のとき') | str('and')
  }
  
  rule(:op_or) {
    str('または') | str('or')
  }
  
  rule(:comment) {
    str("#") >> (newline.absent? >> any).repeat(0) >> newline.maybe
  }
  
  rule(:excepts) {
    separator | arrow | plus | bra | ket | newline | multiply
  }
  
  # event_timing
  
  rule(:before_after) {
    str('前').as(:before) |
    str('後').as(:after)
  }
  
  rule(:event_timing) {
    (
      str('通過').as(:pass) |
      str('移動').as(:move)
    ).as(:timing) >> before_after.as(:before_after)
  }
  
  # event_condition
  
  rule(:event_condition) {
    (
      str('地点').as(:place)
    ).as(:condition)
  }
  
  # event_contents
  
  rule(:event_contents) {
    (
      str('内容')
    ).as(:contents)
  }
  
  # event_steps
  
  rule(:event_step) {
    bra >> event_timing >> ket >> event_condition >> newline >>
    event_contents >> newline.maybe
  }
  
  rule(:event_steps) {
    event_step.repeat(1).as(:steps)
  }
  
  # event_definition
  
  rule(:event_definition) {
    bra >> str('イベント') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    event_steps
  }
  
  # root
  
  root(:event_definition)
  
end
