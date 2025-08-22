#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

class HomebrewTapUpdater {
  constructor() {
    this.casksDir = path.join(__dirname, "Casks");
    this.formulaDir = path.join(__dirname, "Formula");
    this.readmePath = path.join(__dirname, "README.md");
    this.dryRun = process.argv.includes("--dry-run");
  }

  // Parse Cask file
  parseCaskFile(filePath) {
    try {
      const content = fs.readFileSync(filePath, "utf8");
      const fileName = path.basename(filePath, ".rb");

      // Get file last modified time
      const stats = fs.statSync(filePath);
      const lastModified = stats.mtime;

      // Extract version number
      const versionMatch = content.match(/version\s+["']([^"']+)["']/);
      const version = versionMatch ? versionMatch[1] : "Unknown";

      // Extract application name
      const nameMatch = content.match(/name\s+["']([^"']+)["']/);
      const name = nameMatch ? nameMatch[1] : this.formatAppName(fileName);

      // Extract description
      const descMatch = content.match(/desc\s+["']([^"']+)["']/);
      const desc = descMatch ? descMatch[1] : "No description available";

      return {
        fileName,
        name,
        desc,
        version,
        type: "GUI App",
        lastModified,
      };
    } catch (error) {
      console.error(`Error parsing cask file ${filePath}:`, error.message);
      return null;
    }
  }

  // Parse Formula file
  parseFormulaFile(filePath) {
    try {
      const content = fs.readFileSync(filePath, "utf8");
      const fileName = path.basename(filePath, ".rb");

      // Get file last modified time
      const stats = fs.statSync(filePath);
      const lastModified = stats.mtime;

      // Extract version number
      const versionMatch = content.match(/version\s+["']([^"']+)["']/);
      const version = versionMatch ? versionMatch[1] : "Unknown";

      // Extract class name as application name
      const classMatch = content.match(/class\s+(\w+)\s+<\s+Formula/);
      const name = classMatch ? classMatch[1].toLowerCase() : fileName;

      // Extract description
      const descMatch = content.match(/desc\s+["']([^"']+)["']/);
      const desc = descMatch ? descMatch[1] : "No description available";

      return {
        fileName,
        name,
        desc,
        version,
        type: "CLI Tool",
        lastModified,
      };
    } catch (error) {
      console.error(`Error parsing formula file ${filePath}:`, error.message);
      return null;
    }
  }

  // Format application name
  formatAppName(fileName) {
    return fileName
      .split("-")
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(" ");
  }

  // Get all application information
  getAllApps() {
    const apps = [];

    // Parse Casks
    if (fs.existsSync(this.casksDir)) {
      const caskFiles = fs
        .readdirSync(this.casksDir)
        .filter((file) => file.endsWith(".rb"));

      for (const file of caskFiles) {
        const filePath = path.join(this.casksDir, file);
        const appInfo = this.parseCaskFile(filePath);
        if (appInfo) {
          apps.push(appInfo);
        }
      }
    }

    // Parse Formula
    if (fs.existsSync(this.formulaDir)) {
      const formulaFiles = fs
        .readdirSync(this.formulaDir)
        .filter((file) => file.endsWith(".rb"));

      for (const file of formulaFiles) {
        const filePath = path.join(this.formulaDir, file);
        const appInfo = this.parseFormulaFile(filePath);
        if (appInfo) {
          apps.push(appInfo);
        }
      }
    }

    // Sort by last modified time (newest first)
    return apps.sort((a, b) => b.lastModified - a.lastModified);
  }

  // Generate table rows
  generateTableRows(apps) {
    return apps
      .map((app) => {
        const version = app.version.startsWith("v")
          ? app.version
          : `v${app.version}`;
        return `| ${app.name} | ${app.type} | ${app.desc} | ${version} |`;
      })
      .join("\n");
  }

  // Update README.md
  updateReadme() {
    try {
      if (!fs.existsSync(this.readmePath)) {
        console.error("README.md file not found!");
        return false;
      }

      const apps = this.getAllApps();
      console.log(`Found ${apps.length} applications:`);

      apps.forEach((app) => {
        console.log(`  - ${app.name} (${app.type}): v${app.version}`);
      });

      const readmeContent = fs.readFileSync(this.readmePath, "utf8");

      // Find table start and end positions
      const tableStartRegex =
        /\| Application Name\s+\| Type\s+\| Description\s+\| Latest Version\s+\|/;
      const tableHeaderSeparator = /\|\s*-+\s*\|\s*-+\s*\|\s*-+\s*\|\s*-+\s*\|/;

      const startMatch = readmeContent.match(tableStartRegex);
      if (!startMatch) {
        console.error("Could not find application table in README.md");
        return false;
      }

      const startIndex = startMatch.index;
      const headerEndIndex = readmeContent.indexOf("\n", startIndex);
      const separatorEndIndex = readmeContent.indexOf("\n", headerEndIndex + 1);

      // Find table end position (next ## title or end of file)
      const afterTable = readmeContent.substring(separatorEndIndex + 1);
      const nextSectionMatch = afterTable.match(/\n## /);
      const tableEndIndex = nextSectionMatch
        ? separatorEndIndex + 1 + nextSectionMatch.index
        : readmeContent.length;

      // Build new README content
      const beforeTable = readmeContent.substring(0, separatorEndIndex + 1);
      const afterTableContent = readmeContent.substring(tableEndIndex);
      const newTableRows = this.generateTableRows(apps);

      const newContent = beforeTable + newTableRows + "\n" + afterTableContent;

      if (this.dryRun) {
        console.log("\n=== DRY RUN MODE ===");
        console.log("New table content would be:");
        console.log(newTableRows);
        console.log("\n=== END DRY RUN ===");
        return true;
      }

      fs.writeFileSync(this.readmePath, newContent, "utf8");
      console.log("\n✅ README.md updated successfully!");

      return true;
    } catch (error) {
      console.error("Error updating README.md:", error.message);
      return false;
    }
  }

  // Check version consistency
  checkVersionConsistency() {
    console.log("\n🔍 Checking for version inconsistencies...");

    const apps = this.getAllApps();
    const readmeContent = fs.readFileSync(this.readmePath, "utf8");

    let hasInconsistencies = false;

    apps.forEach((app) => {
      const versionInReadme = this.extractVersionFromReadme(
        readmeContent,
        app.name
      );
      if (versionInReadme && versionInReadme !== `v${app.version}`) {
        console.log(
          `⚠️  ${app.name}: README shows ${versionInReadme}, actual is v${app.version}`
        );
        hasInconsistencies = true;
      }
    });

    if (!hasInconsistencies) {
      console.log("✅ All versions are consistent!");
    }

    return !hasInconsistencies;
  }

  // Extract version number from README
  extractVersionFromReadme(content, appName) {
    const regex = new RegExp(
      `\\|\\s*${appName}\\s*\\|[^\\|]*\\|[^\\|]*\\|\\s*([^\\|\\s]+)\\s*\\|`,
      "i"
    );
    const match = content.match(regex);
    return match ? match[1].trim() : null;
  }

  // Run the updater
  run() {
    console.log("🚀 Starting Homebrew Tap README updater...");

    if (this.dryRun) {
      console.log("📋 Running in DRY RUN mode - no files will be modified");
    }

    // Check version consistency
    this.checkVersionConsistency();

    // Update README
    const success = this.updateReadme();

    if (success) {
      console.log("\n🎉 Update completed successfully!");
    } else {
      console.log("\n❌ Update failed!");
      process.exit(1);
    }
  }
}

// Run the updater
if (require.main === module) {
  const updater = new HomebrewTapUpdater();
  updater.run();
}

module.exports = HomebrewTapUpdater;
