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

    # make default search a fuzzy search if not manually specified already
    query = query.split(' ').*.+('~').join(' ') unless query.grep(/~/) or query.blank?

    # if no results and it doesn't already include AND/OR which breaks solr, try it as an OR search
    begin
      if Question.count_by_solr(query) == 0 and
                        query.split(' ').grep(/^(and|or|[^!\\])$/i).blank?
        query = query.split(' ').try.join(' OR ') || @query 
      end

      @questions = Question.solr_paginated_search(query,
                        :page => (params[:page] or 1), 
                        :per_page => 10)
    rescue => e
      hobo_index Question.none
      flash[:error] = "Search syntax error.  Please simplify your phrase or eliminate special characters."
    end
    @questions.member_class = Question
  end

end
