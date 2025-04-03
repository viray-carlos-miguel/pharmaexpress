plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.untitled"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Specify your own unique Application ID.
        applicationId = "com.example.untitled"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        release {
            if (System.getenv()["CI"]) { // CI=true is exported by services like Codemagic
                storeFile file(System.getenv()["keyproperties64"]) // Keystore file path
                storePassword System.getenv()["keystorepassword"]
                keyAlias System.getenv()["alias"]
                keyPassword System.getenv()["keypassword"]
            } else {
                // Read the keystore properties file for local development
                def keystoreProperties = new Properties()
                def keystorePropertiesFile = rootProject.file("keystore.properties")
                if (keystorePropertiesFile.exists()) {
                    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
                }

                keyAlias keystoreProperties['alias']
                keyPassword keystoreProperties['keypassword']
                storeFile keystoreProperties['keyproperties'] ? file(keystoreProperties['keyproperties']) : null
                storePassword keystoreProperties['keystorepassword']
            }
        }
    }

    buildTypes {
        release {
            // Enable minification if needed for release
            minifyEnabled false  // Change to true if you want to use ProGuard/R8
            shrinkResources false  // Set to true if you need to shrink resources

            signingConfig signingConfigs.release

                    // Enable Proguard rules if using minification
                    proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

flutter {
    source = "../.." // Ensure this points to the correct location of your Flutter SDK
}
