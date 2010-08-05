class QuestionsController < ApplicationController

  hobo_model_controller

  auto_actions :edit, :update, :destroy, :show
  
  auto_actions_for :user, [:index, :new, :create]
  
  auto_actions_for :recipes, :index
  
  def index; end
  
  index_action :answered, :scope => :with_answers
  index_action :open,     :scope => :without_answers

  index_action :search
  def search
    query = @query = params[:query] || ''

    begin
      @questions = Question.search do
        paginate(:page => (params[:page] or 1), :per_page => 10)
        keywords(query)
      end.results
    rescue => e
      # special characters can sometimes cause solr exceptions, catch and display error
      hobo_index Question.none
      flash[:error] = "Search syntax error.  Please simplify your phrase or eliminate special characters."
    end
    @questions.member_class = Question
  end

end
