# coding: utf-8
# 在数据库中的配置信息
# 这里有存放首页,Wiki 等页面 HTML
# 使用方法
# SiteConfig.foo
# SiteConfig.foo = "asdkglaksdg"
class SiteConfig
  include Mongoid::Document
  
  field :key
  field :value
  
  index :key
  
  validates_presence_of :key
  validates_uniqueness_of :key
  
  def self.method_missing(method, *args)
    method_name = method.to_s
    super(method, *args)
  rescue NoMethodError
    if method_name =~ /=$/
      var_name = method_name.gsub('=', '')
      value = args.first.to_s
      # save
      if item = find_by_key(key)
        update_attribute(var_name, value)
      else
        SiteConfig.create(:key => key, :value => value)
      end
    else
      if item = where(:key => method).first
        item.value
      else
        nil
      end
    end
  end
  
  def self.find_by_key(key)
    where(:key => key).first
  end
  
  def self.save_default(key, value)
    if not find_by_id(key)
      create(:key => key, :value => value.to_s)
    end
  end
end