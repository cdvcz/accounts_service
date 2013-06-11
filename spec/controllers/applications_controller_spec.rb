# encoding: utf-8

require 'spec_helper'

describe ApplicationsController do
  before do
    @application_1 = Application.create!(name: "intranet")
    @application_2 = Application.create!(name: "upd")
  end

  ## INDEX ####################################################################
  it "vrati seznam aplikaci" do
    get :index, format: :json

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    body["content"].count.should == 2
    body["content"][0]["application"]["name"].should == 'intranet'
    body["content"][1]["application"]["name"].should == 'upd'
    body["meta"]["total_pages"].should == 1
    body["meta"]["total_entries"].should == 2
  end

  ## SHOW #####################################################################
  it "vrati detail aplikace" do
    get :show, id: @application_1.id, format: :json

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    %w{id name}.each do |attribute|
      body["content"]["application"][attribute].should == @application_1.send(attribute.to_sym)
    end
  end

  ## CREATE ###################################################################
  it "vytvori aplikaci" do
    post :create, format: :json, application: { name: 'nsbsp' }

    response.status.should == 200
    body = ActiveSupport::JSON.decode(response.body)
    body["content"]["application"]["id"].should == Application.last.id
  end

  it "nevytvori aplikaci bez nazvu" do
    post :create, format: :json, application: { name: "" }

    response.status.should == 422
    body = ActiveSupport::JSON.decode(response.body)
    body["content"]["errors"]["name"].should include "Toto pole nemůže zůstat prázdné"
  end

  ## UPDATE ###################################################################
  it "upravi aplikaci" do
    put :update,
      format: :json,
      id: @application_1.id,
      application: { name: "Robot intranet" }

    response.status.should == 204
  end

  it "neupravi aplikaci bez nazvu" do
    post :update,
      format: :json,
      id: @application_1.id,
      application: { name:  ""}

    response.status.should == 422
    body = ActiveSupport::JSON.decode(response.body)
    body["content"]["errors"]["name"].should include "Toto pole nemůže zůstat prázdné"
  end

  ## DESTROY ###################################################################
  it "smaze aplikaci" do
    delete :destroy, format: :json, id: @application_1.id
    response.status.should == 204
  end
end
