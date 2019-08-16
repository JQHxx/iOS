//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.file` struct is generated, and contains static references to 8 files.
  struct file {
    /// Resource file `thanos_dust_1.mp3`.
    static let thanos_dust_1Mp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "thanos_dust_1", pathExtension: "mp3")
    /// Resource file `thanos_dust_2.mp3`.
    static let thanos_dust_2Mp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "thanos_dust_2", pathExtension: "mp3")
    /// Resource file `thanos_dust_3.mp3`.
    static let thanos_dust_3Mp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "thanos_dust_3", pathExtension: "mp3")
    /// Resource file `thanos_dust_4.mp3`.
    static let thanos_dust_4Mp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "thanos_dust_4", pathExtension: "mp3")
    /// Resource file `thanos_dust_5.mp3`.
    static let thanos_dust_5Mp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "thanos_dust_5", pathExtension: "mp3")
    /// Resource file `thanos_dust_6.mp3`.
    static let thanos_dust_6Mp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "thanos_dust_6", pathExtension: "mp3")
    /// Resource file `thanos_reverse_sound.mp3`.
    static let thanos_reverse_soundMp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "thanos_reverse_sound", pathExtension: "mp3")
    /// Resource file `thanos_snap_sound.mp3`.
    static let thanos_snap_soundMp3 = Rswift.FileResource(bundle: R.hostingBundle, name: "thanos_snap_sound", pathExtension: "mp3")
    
    /// `bundle.url(forResource: "thanos_dust_1", withExtension: "mp3")`
    static func thanos_dust_1Mp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.thanos_dust_1Mp3
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "thanos_dust_2", withExtension: "mp3")`
    static func thanos_dust_2Mp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.thanos_dust_2Mp3
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "thanos_dust_3", withExtension: "mp3")`
    static func thanos_dust_3Mp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.thanos_dust_3Mp3
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "thanos_dust_4", withExtension: "mp3")`
    static func thanos_dust_4Mp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.thanos_dust_4Mp3
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "thanos_dust_5", withExtension: "mp3")`
    static func thanos_dust_5Mp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.thanos_dust_5Mp3
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "thanos_dust_6", withExtension: "mp3")`
    static func thanos_dust_6Mp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.thanos_dust_6Mp3
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "thanos_reverse_sound", withExtension: "mp3")`
    static func thanos_reverse_soundMp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.thanos_reverse_soundMp3
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "thanos_snap_sound", withExtension: "mp3")`
    static func thanos_snap_soundMp3(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.thanos_snap_soundMp3
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 6 images.
  struct image {
    /// Image `baidu`.
    static let baidu = Rswift.ImageResource(bundle: R.hostingBundle, name: "baidu")
    /// Image `google`.
    static let google = Rswift.ImageResource(bundle: R.hostingBundle, name: "google")
    /// Image `juejin`.
    static let juejin = Rswift.ImageResource(bundle: R.hostingBundle, name: "juejin")
    /// Image `thanos_snap`.
    static let thanos_snap = Rswift.ImageResource(bundle: R.hostingBundle, name: "thanos_snap")
    /// Image `thanos_time`.
    static let thanos_time = Rswift.ImageResource(bundle: R.hostingBundle, name: "thanos_time")
    /// Image `wikipedia`.
    static let wikipedia = Rswift.ImageResource(bundle: R.hostingBundle, name: "wikipedia")
    
    /// `UIImage(named: "baidu", bundle: ..., traitCollection: ...)`
    static func baidu(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.baidu, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "google", bundle: ..., traitCollection: ...)`
    static func google(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.google, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "juejin", bundle: ..., traitCollection: ...)`
    static func juejin(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.juejin, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "thanos_snap", bundle: ..., traitCollection: ...)`
    static func thanos_snap(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.thanos_snap, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "thanos_time", bundle: ..., traitCollection: ...)`
    static func thanos_time(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.thanos_time, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "wikipedia", bundle: ..., traitCollection: ...)`
    static func wikipedia(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.wikipedia, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
      try main.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = ViewController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
