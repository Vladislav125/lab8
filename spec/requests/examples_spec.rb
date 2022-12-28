require 'rails_helper'

RSpec.describe "Examples", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /show" do
    it "returns http status 200" do
      get "/example/show", params:{input_value:8}
      expect(response).to have_http_status(200)
    end

    context 'returns http code 302' do
      it "has no parametrs" do
        get "/example/show"
        expect(response).to have_http_status(302)
      end
      
      it "has empty string" do
        get "/example/show", params:{input_value:""}
        expect(response).to have_http_status(302)
      end

      it "has not number symbol" do
        get "/example/show", params:{input_value:"qwerty"}
        expect(response).to have_http_status(302)
      end
    end

    context 'controller tests' do
      it 'test @number' do
        get '/example/show', params:{input_value:8}
        expect(assigns(:number)).to eq(9)
      end

      it 'test @factorial' do
        get '/example/show', params:{input_value:8}
        expect(assigns(:factorial)).to eq(362880)
      end
    end

    context 'redirect to input page' do
      it "has no parametrs" do
        get "/example/show"
        expect(response).to redirect_to(root_path)
      end
      
      it "has empty string" do
        get "/example/show", params:{input_value:""}
        expect(response).to redirect_to(root_path)
      end

      it "has not number symbol" do
        get "/example/show", params:{input_value:"qwerty"}
        expect(response).to redirect_to(root_path)
      end
    end

    context 'parse answer' do
      it 'parameter 7' do
        get "/example/show", params:{input_value: 7}
        html = Nokogiri::HTML(response.body)
        answer = [["3!", "6", "1, 2, 3"], ["4!", "24", "2, 3, 4"], ["5!", "120", "4, 5, 6"], ["6!", "720", "8, 9, 10"]]
        td = html.search('td')
        answer.each_with_index do |trio, index|
          expected = [td[3 * index].text, td[1 + 3 * index].text, td[2 + 3 * index].text]
          expect(expected).to eq(trio)
        end
      end
    end
  end
end
