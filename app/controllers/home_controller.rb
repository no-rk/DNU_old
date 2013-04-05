class HomeController < ApplicationController
  def index
  end
  
  # テスト用処理
  def kousin
    DNU::Process::Update.start(true)
    redirect_to({ :action => :index }, :notice => "更新処理を試みた。")
  end
  def saikousin
    DNU::Process::Update.start
    redirect_to({ :action => :index }, :notice => "再更新処理を試みた。")
  end
  def kousinstate
    Day.toggle_settled_pending
    redirect_to({ :action => :index }, :notice => "結果状態の変更を試みた。")
  end
end
