require 'rubygems'
require 'rubyXL'

describe RubyXL::Parser do

  before do
    @workbook = RubyXL::Workbook.new
    @workbook.add_worksheet("Test Worksheet")

    ws = @workbook.add_worksheet("Escape Test")
    ws.add_cell(0,0, "&")
    ws.add_cell(0,1, "<")
    ws.add_cell(0,2, ">")

    ws.add_cell(1,0, "&")#TODO#.datatype = RubyXL::Cell::SHARED_STRING
    ws.add_cell(1,1, "<")#TODO#.datatype = RubyXL::Cell::SHARED_STRING
    ws.add_cell(1,2, ">")#TODO#.datatype = RubyXL::Cell::SHARED_STRING

    @time_str = Time.now.to_s
    @file = @time_str + '.xlsx'
    @workbook.write(@file)
  end

  describe '.parse' do
    it 'should parse a valid Excel xlsx or xlsm workbook correctly' do
      @workbook2 = RubyXL::Parser.parse(@file)

      @workbook2.worksheets.size.should == @workbook.worksheets.size
      @workbook2[0].sheet_data.should == @workbook[0].sheet_data
      @workbook2[0].sheet_name.should == @workbook[0].sheet_name
    end

    it 'should cause an error if an xlsx or xlsm workbook is not passed' do
      lambda {@workbook2 = RubyXL::Parser.parse(@time_str+".xls")}.should raise_error
    end

    it 'should not cause an error if an xlsx or xlsm workbook is not passed but the skip_filename_check option is used' do
      filename = @time_str
      FileUtils.cp(@file, filename)
      
      lambda {@workbook2 = RubyXL::Parser.parse(filename)}.should raise_error
      lambda {@workbook2 = RubyXL::Parser.parse(filename, :skip_filename_check => true)}.should_not raise_error
      
      File.delete(filename)
    end
    
    it 'should only read the data and not any of the styles (for the sake of speed) when passed true' do
      @workbook2 = RubyXL::Parser.parse(@file, :data_only => true)

      @workbook2.worksheets.size.should == @workbook.worksheets.size
      @workbook2[0].sheet_data.should == @workbook[0].sheet_data
      @workbook2[0].sheet_name.should == @workbook[0].sheet_name
    end

    it 'should construct consistent number formats' do
      @workbook2 = RubyXL::Parser.parse(@file)
      @workbook2.num_fmts.should be_an(Array)
# Need to directly read XML to check the size...
#      @workbook2.num_fmts.size.should == @workbook2.num_fmts[:attributes][:count]
    end

    it 'should unescape HTML entities properly' do
      @workbook2 = RubyXL::Parser.parse(@file)
      @workbook2["Escape Test"][0][0].value.should == "&"
      @workbook2["Escape Test"][0][1].value.should == "<"
      @workbook2["Escape Test"][0][2].value.should == ">"

      @workbook2["Escape Test"][1][0].value.should == "&"
      @workbook2["Escape Test"][1][1].value.should == "<"
      @workbook2["Escape Test"][1][2].value.should == ">"
    end

  end

  after do
    if File.exist?(@file)
      File.delete(@file)
    end
  end
end
