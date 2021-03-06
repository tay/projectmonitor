require 'spec_helper'

describe ProjectStatus do
  describe 'factories' do
    it 'should be valid project_status' do
      FactoryGirl.build(:project_status).should be_valid
    end
  end

  describe ".recent" do
    let(:project) { FactoryGirl.create(:jenkins_project) }
    let!(:status2) { project.statuses.create(build_id: 2, published_at: 3.years.ago) }
    let!(:status1) { project.statuses.create(build_id: 1, published_at: 2.years.ago) }

    context "for just one project" do
      it "returns statuses sorted by published_at" do
        project.statuses.recent.should == [status1, status2]
      end

      it "returns statuses that have a build_id" do
        status0 = project.statuses.create(build_id: nil, published_at: 1.year.ago)
        project.statuses.recent.should_not include(status0)
      end
    end
  end

  describe ".latest" do
    let(:project) { FactoryGirl.create(:jenkins_project) }
    let!(:status2) { project.statuses.create(build_id: 2, published_at: 3.years.ago) }
    let!(:status1) { project.statuses.create(build_id: 1, published_at: 2.years.ago) }

    it "returns the last status" do
      project.statuses.latest.should == status1
    end
  end

  describe "#in_words" do
    it "returns success for a successful status" do
      status = project_statuses(:socialitis_status_green_01)
      status.in_words.should == 'success'
    end

    it "returns failure for a failed status" do
      status = project_statuses(:socialitis_status_old_red_00)
      status.in_words.should == 'failure'
    end
  end
end
