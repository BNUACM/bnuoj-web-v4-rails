class Problem < ActiveRecord::Base
  self.table_name = "problem"
  self.primary_key = "pid"

  has_one :oj_info, primary_key: "vname", foreign_key: "name"
  has_many :discusses, primary_key: 'pid', foreign_key: 'pid', inverse_of: :problem
  scope :public, -> { where(hide: 0) }
  scope :user_unsolved, ->(username) { 
    where(' pid NOT IN ( SELECT DISTINCT(pid) FROM status WHERE result = "Accepted" AND username = ? ) ', username)
  }

  # External Url for virtual problems.
  def to_url
    @to_url ||= begin
      case vname
      when "PKU"
        "http://acm.pku.edu.cn/JudgeOnline/problem?id=#{vid}"
      when "OpenJudge"
        "http://poj.openjudge.cn/practice/#{vid}"
      when "CodeForces"
        "http://codeforces.com/problemset/problem/#{vid[/\\d+/]}#{vid[/[^\\d]+/]}"
      when "HDU"
        "http://acm.hdu.edu.cn/showproblem.php?pid=#{vid}"
      when "SGU"
        "http://acm.sgu.ru/problem.php?contest=0&problem=#{vid}"
      when "LightOJ"
        "http://www.lightoj.com/volume_showproblem.php?problem=#{vid}"
      when "Ural"
        "http://acm.timus.ru/problem.aspx?num=#{vid}"
      when "ZJU"
        "http://acm.zju.edu.cn/onlinejudge/showProblem.do?problemCode=#{vid}"
      when "SPOJ"
        "http://www.spoj.pl/problems/#{vid}/"
      when "UESTC"
        "http://acm.uestc.edu.cn/problem.php?pid=#{vid}"
      when "FZU"
        "http://acm.fzu.edu.cn/problem.php?pid=#{vid}"
      when "NBUT"
        "http://cdn.ac.nbutoj.com/Problem/view.xhtml?id=#{vid}"
      when "WHU"
        "http://acm.whu.edu.cn/land/problem/detail?problem_id=#{vid}"
      when "SYSU"
        "http://soj.me/#{vid}"
      when "SCU"
        "http://cstest.scu.edu.cn/soj/problem.action?id=#{vid}"
      when "HUST"
        "http://acm.hust.edu.cn/problem.php?id=#{vid}"
      when "UVALive"
        vvid = vid.to_i
        vvid = vvid + 10 if vvid > 5722
        "http://livearchive.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=#{vvid-1999}"
      else
        begin
          VUrl.where(voj: vname, vid: vid).first.url
        rescue Exception => e
          ""
        end
      end
    end
  end

  # Get categories for this problem.
  def tagged_categories
    ProblemCategory.joins(:category).includes(:category).where(pid: pid).where('weight > 0')
  end
end
