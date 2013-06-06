# encoding: utf-8

require 'spec_helper'

describe AccountApplicationsController do
  before do
    @account_1 = Account.create!(
      name: "Robot Intranet", login: "robot", password: 'heslo')

    @account_2 = Account.create!(
      name: "Eliška Kutnohorská", login: "eliska", password: 'heslo')

    @application_1 = Application.create!(name: "app")
    @application_2 = Application.create!(name: "upd")

    @aa_1 = AccountApplication.create!(
      account: @account_1, application: @application_1, user_id: 3)

    @aa_2 = AccountApplication.create!(
      account: @account_2, application: @application_2, user_id: 4)
  end

  ## INDEX ####################################################################
  it "vrati seznam" do
    get :index, format: :json

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    body.count.should == 2
    body[0]["account_application"]["application_id"].should == @application_1.id
    body[1]["account_application"]["application_id"].should == @application_2.id

    #body["meta"]["total_pages"].should == 1
    #body["meta"]["total_entries"].should == 2
  end

  ## SHOW #####################################################################
  it "vrati detail" do
    get :show, id: @aa_1.id, format: :json

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    %w{id account_id application_id user_id}.each do |attribute|
      body["account_application"][attribute].should == @aa_1.send(attribute.to_sym)
    end
  end

  ## CREATE ###################################################################
  it "vytvori account_application" do
    post :create, format: :json,
      account_application: {
        account_id: @account_1.id,
        application_id: @application_1.id }

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    body["account_application"]["id"].should == AccountApplication.last.id
  end

  it "nevytvori account_application bez id aplikace" do
    post :create, format: :json, account_application: { account_id: 1 }

    response.status.should == 422
    body = ActiveSupport::JSON.decode(response.body)
    body["errors"]["application"].should include "Toto pole nemůže zůstat prázdné"
  end

  ## UPDATE ###################################################################
  it "upravi account_application" do
    put :update,
      format: :json,
      id: @aa_1.id,
      account_application: { application_id: @application_1.id }

    response.status.should == 204
  end

  it "neupravi aplikaci bez id aplikace" do
    post :update,
      format: :json,
      id: @aa_1.id,
      account_application: { application: nil }

    response.status.should == 422
    body = ActiveSupport::JSON.decode(response.body)
    body["errors"]["application"].should include "Toto pole nemůže zůstat prázdné"
  end

  ## DESTROY ###################################################################
  it "smaze account_application" do
    delete :destroy, format: :json, id: @aa_1.id
    response.status.should == 204
  end
end
