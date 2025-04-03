import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.developer.milkteashop"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.developer.milkteashop"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Load keystore properties for signing
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties()

    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    } else {
        throw GradleException("Key properties file not found.")
    }

    // Debugging: Log the keystore file path
    val keystoreFilePath = keystoreProperties["storeFile"]?.toString()
    if (keystoreFilePath.isNullOrEmpty()) {
        throw GradleException("Keystore file path is empty or null!")
    }

    // Resolve relative path to absolute path (keystore path should now be correct)
    val keystoreFile = file(keystoreFilePath)
    if (!keystoreFile.exists()) {
        throw GradleException("Keystore file does not exist at path: $keystoreFilePath")
    }

    println("Using keystore file path: $keystoreFilePath")

    signingConfigs {
        create("release") {
            storeFile = keystoreFile
            storePassword = keystoreProperties["storePassword"]?.toString() ?: throw GradleException("Keystore password not specified")
            keyAlias = keystoreProperties["keyAlias"]?.toString() ?: throw GradleException("Key alias not specified")
            keyPassword = keystoreProperties["keyPassword"]?.toString() ?: throw GradleException("Key password not specified")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
