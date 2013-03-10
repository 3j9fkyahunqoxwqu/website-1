require 'spec_helper'

feature 'Posts' do

  scenario 'List and read posts' do
    Fabricate(:post, title: 'Foo', content: 'Hey')
    visit '/en/news'
    page.should have_content 'Foo'
    click_on "Foo"
    page.should have_content 'Hey'
  end

  scenario 'RSS Feed' do
    visit '/en/news.rss'
    page.response_headers['Content-Type'].should =~ /rss/
  end

  scenario 'Add post' do
    sign_in_as(Fabricate(:admin))
    visit '/en/news/new'
    fill_in :post_title, with: 'My title'
    fill_in :post_content, with: 'My content'
    fill_in :post_posted_at, with: '2013-12-01'
    click_button 'Save'
    page.should have_content 'My title'
    post = Post.first
    post.title.should == 'My title'
  end

  scenario 'Edit post' do
    Fabricate(:post, title: 'Foo', content: 'Hey')
    sign_in_as(Fabricate(:admin))
    visit '/en/news/1/edit'
    fill_in :post_title, with: 'My title'
    click_button 'Save'
    page.should have_content 'My title'
    post = Post.first
    post.title.should == 'My title'
  end

end