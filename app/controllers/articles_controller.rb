class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :ensure_current_user, only: %i[edit update destroy]
  before_action :ensure_authority_user, only: %i[new create]

  def index
    @articles = Article.all
    @articles = Article.order("created_at #{sort_direction}")
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      EmployeeArticle.create(employee_id: session[:user_id], article_id: @article.id)
      redirect_to articles_path, notice: "お知らせ「#{@article.title}」を登録しました。"
    else
      render :new
    end
  end

  def show
    @employees = Employee.where(deleted_at: nil)
    unless EmployeeArticle.find_by(article_id: params[:id], employee_id: session[:user_id]).present?
      EmployeeArticle.create(article_id: params[:id], employee_id: session[:user_id])
    end
    @already_read = EmployeeArticle.where(article_id: params[:id])
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to articles_path, notice: "お知らせ「#{@article.title}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "お知らせ「#{@article.title}」を削除しました。"
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :author)
  end

  def ensure_current_user
    return if current_user.id == @article.author

    redirect_to articles_path, notice: '他のユーザーの投稿を変更することはできません。'
  end

  def ensure_authority_user
    return if current_user.news_posting_auth

    redirect_to articles_path, notice: 'お知らせ投稿権限がありません。'
  end

  def sort_direction
    params[:direction] || 'asc'
  end
end
