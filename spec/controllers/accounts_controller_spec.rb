# encoding: utf-8

require 'spec_helper'

describe AccountsController do
  before do
    @account_1 = Account.create!(name: "Jara Cimrman", login: "jara", password: 'heslo')
    @account_2 = Account.create!(name: "Varel Frištenský", login: "varel", password: 'heslo')
  end

  ## INDEX ####################################################################
  it "vrati seznam uctu" do
    get :index, app_id: 1, format: :json

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    body["content"].count.should == 2
    body["content"][0]["account"]["name"].should == 'Jara Cimrman'
    body["content"][1]["account"]["name"].should == 'Varel Frištenský'

    body["meta"]["total_pages"].should == 1
    body["meta"]["total_entries"].should == 2
  end

  ## SHOW #####################################################################
  it "vrati detail uctu" do
    get :show, id: @account_1.id, format: :json

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    %w{id name login status}.each do |attribute|
      body["content"]["account"][attribute].should == @account_1.send(attribute.to_sym)
    end
  end

  ## CREATE ###################################################################
  it "vytvori ucet" do
    post :create, format: :json, account: ACCOUNT_ATTRIBUTES

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    body["content"]["account"]["id"].should == Account.last.id
  end

  it "nevytvori ucet bez nazvu" do
    post :create, format: :json, account: ACCOUNT_ATTRIBUTES.merge(name: "")

    response.status.should == 422
    body = ActiveSupport::JSON.decode(response.body)
    body["content"]["errors"]["name"].should include "Toto pole nemůže zůstat prázdné"
  end

  ## UPDATE ###################################################################
  it "upravi ucet" do
    put :update,
      format: :json,
      id: @account_1.id,
      account: { name: "Robot intranet" }

    response.status.should == 204
  end

  it "neupravi ucet bez nazvu" do
    post :update,
      format: :json,
      id: @account_1.id,
      account: { name:  ""}

    response.status.should == 422
    body = ActiveSupport::JSON.decode(response.body)
    body["content"]["errors"]["name"].should include "Toto pole nemůže zůstat prázdné"
  end

  ## DESTROY ###################################################################
  it "smaze ucet" do
    delete :destroy, format: :json, id: @account_1.id
    response.status.should == 204
  end

  ACCOUNT_ATTRIBUTES = {
      name: "Karel Němec",
      status: 1,
      password: "nemec",
      login: "nemec"}


  ## AUTHENTICATE ##############################################################
  describe "#authenticate" do
    before do
      account = Account.create!(
        name: "Robot Intranet",
        login: "robot",
        password: 'heslo')

      @application = Application.create!(name: "app", id: 'app')

      AccountApplication.create!(account_id: account.id,
                                 application_id: @application.id,
                                 user_id: 155)
    end

    it "se spravnymi udaji vrati uzivatele" do
      get :authenticate,
        format: :json,
        application_code: 'app',
        login: 'robot',
        password: 'heslo'

      response.status.should == 200
      body = ActiveSupport::JSON.decode(response.body)
      body["content"]["account_application"]["user_id"].should == 155
    end

    it "s nespravnymi udaji vrati chybu" do
      get :authenticate,
        format: :json,
        application_id: @application.id,
        login: 'robot',
        password: 'spatneheslo'

      response.status.should == 401
    end

    it "s spravnymi udaji ale jinou aplikaci vrati chybu" do
      get :authenticate,
        format: :json, application_id: (@application.id + 1), login: 'robot', password: 'heslo'

      response.status.should == 401
    end
  end
end
