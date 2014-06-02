class Admin::DashboardsController < ApplicationController
  require 'gattica'
  layout 'admin_application'

  def show
    ga = Gattica.new({
      email: ENV['GOOGLE_EMAIL'],
      password: ENV['GOOGLE_PASS'] 
    })
    puts ga.token
    ga.profile_id = 41887443

    data = ga.get({
      start_date: '2014-01-01',
      end_date: '2014-03-04',
      dimensions: ['month', 'year'],
      metrics: ['visitors']
    })

    my_json = data.to_h['points'].to_json
    puts my_json

  end

end
