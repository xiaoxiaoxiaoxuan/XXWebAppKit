Pod::Spec.new do |s|
    s.name         = 'XXWebAppKit'
    s.version      = '1.0'
    s.summary      = 'An web app kit'
    s.homepage     = 'https://github.com/xiaoxiaoxiaoxuan/XXWebAppKit'
    s.license      = 'MIT'
    s.authors      = {'Wang Xiaoxuan' => '596384514@qq.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/xiaoxiaoxiaoxuan/XXWebAppKit.git', :tag => s.version}
    s.source_files = 'XXWebAppKit/**/*.{h,m}'
    s.requires_arc = true
    #s.dependency 'MJRefresh'
end
