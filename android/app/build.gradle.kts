import java.io.File
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin must be last
}

// ✅ Define Flutter SDK versions explicitly
ext {
    set("flutter.compileSdkVersion", 35) // Change as needed
    set("flutter.minSdkVersion", 21) // Minimum SDK version
    set("flutter.targetSdkVersion", 33) // Target SDK version
    set("flutter.ndkVersion", "27.0.12077973") // NDK version for compatibility
}

android {
    // ✅ Specify namespace (MUST be set to avoid build errors)
    namespace = "com.example.untitled" // Change to your package name

    compileSdk = project.extra["flutter.compileSdkVersion"] as Int
    ndkVersion = project.extra["flutter.ndkVersion"] as String

    defaultConfig {
        applicationId = "com.example.untitled"
        minSdk = project.extra["flutter.minSdkVersion"] as Int
        targetSdk = project.extra["flutter.targetSdkVersion"] as Int
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("key.properties")
            val keystoreProperties = Properties()

            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
            } else {
                throw GradleException("Missing keystore.properties file!")
            }

            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")


        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )
        }
    }
}

flutter {
    source = "../.." // Ensure this points to the correct Flutter SDK location
}
