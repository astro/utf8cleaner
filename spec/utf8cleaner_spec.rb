# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../ext/utf8cleaner'
require 'iconv'

describe UTF8Cleaner do
  context "when cleaning valid input" do
    it "should preserve ASCII" do
      UTF8Cleaner.clean("foobar").
        should == "foobar"
    end

    it "should preserve Umlauts" do
      UTF8Cleaner.clean("mäh").
        should == "mäh"
    end

    it "should preserve Umlauts at the front" do
      UTF8Cleaner.clean("Äusserst").
        should == "Äusserst"
    end

    it "should preserve Umlauts at the end" do
      UTF8Cleaner.clean("Gauß").
        should == "Gauß"
    end

    it "should not shorten Korean truncated with valid replacement character" do
      UTF8Cleaner.clean("양 10m 1:01.7 슈�....").
        should == "양 10m 1:01.7 슈�...."
    end
  end

  context "when cleaning invalid input" do
    it "should remove 0 bytes" do
      UTF8Cleaner.clean("foo\0bar").
        should == "foobar"
    end

    def utf8_to_latin1(s)
      Iconv.open('ISO_8859-1', 'UTF-8') { |cd|
        cd.iconv(s)
      }
    end

    it "should remove broken Umlauts" do
      UTF8Cleaner.clean(utf8_to_latin1("Mäuse")).
        should == "Muse"
    end

    it "should remove broken Umlauts at the front" do
      UTF8Cleaner.clean(utf8_to_latin1("Äusserst")).
        should == "usserst"
    end

    it "should remove broken Umlauts at the end" do
      UTF8Cleaner.clean(utf8_to_latin1("Gauß")).
        should == "Gau"
    end


    it "should shorten truncated Korean" do
      UTF8Cleaner.clean("량\354....").
        should == "량...."
    end
  end
end
