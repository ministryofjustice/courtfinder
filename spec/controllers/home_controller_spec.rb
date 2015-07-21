require 'spec_helper'

describe HomeController do
  render_views

  let!(:court) { create(:court, old_id: 1, name: "A court of L.A.W.") }

  context "landing page" do
    it "displays the landing page" do
      get :index
      response.should be_success
    end
  end

  context "legacy url redirection" do
    it "redirects by court_id" do
      get :index, court_id: court.old_id
      response.should redirect_to(court_path(court))
      response.status.should == 301
    end

    it "redirects to a legacy formfinder leaflet" do
      get :index, court_leaflets_id: 0
      response.should redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetLeaflet.do?court_leaflets_id=0")
      response.status.should == 302
    end

    it "redirects to a legacy formfinder form" do
      get :index, court_forms_id: 0
      response.should redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetForm.do?court_forms_id=0")
      response.status.should == 302
    end
  end

  context 'ping.json endpoint' do
    context 'when ping.json file not present' do
      before { get :ping }

      it 'returns an empty result' do
        expect(JSON.parse(response.body)).to eq({})
      end
    end

    context 'when ping.json file present' do
      let(:expected_json) do
        {
          'version_number'  => '123',
          'build_date'      => '20150721',
          'commit_id'       => 'afb12cb3',
          'build_tag'       => 'test'
        }
      end

      before do
        allow(File).to receive(:read).and_return(expected_json.to_json)
        get :ping
      end

      it 'returns JSON with app information' do
        expect(JSON.parse(response.body)).to eq(expected_json)
      end
    end
  end
end
