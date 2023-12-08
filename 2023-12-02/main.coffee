#!/usr/bin/env coffee

fs = require 'fs'

chalk = require 'chalk'
yargs = require 'yargs/yargs'

{ hideBin } = require 'yargs/helpers'
{ solvers } = require './lib'

argv = yargs hideBin process.argv
  .scriptName 'main.coffee'

  .version false
  .strict true

  .help 'help'
  .alias('help', 'h')

  .command {
    command: ['$0 [-s <solver>] <reds> <greens> <blues> <file>']
    desc: 'Pass file and requirements to given solver'
    builder: (yargs) ->
      yargs
        .option 'solver', {
          describe: 'Solver number (1 to ' + solvers.length + ')'
          alias: 's'
          type: 'number'
          choices: [1..solvers.length]
          default: 1
        }
        .positional 'reds', {
          describe: 'Red cubes required'
          type: 'number'
          demandOption: true
        }
        .positional 'greens', {
          describe: 'Green cubes required'
          type: 'number'
          demandOption: true
        }
        .positional 'blues', {
          describe: 'Blue cubes required'
          type: 'number'
          demandOption: true
        }
        .positional 'file', {
          describe: 'Input file to process'
          type: 'string'
          demandOption: true
        }

    handler: (argv) ->
      fs.stat argv.file, (err, stats) ->
        if err
          console.error chalk.red err
          process.exit 1

        if not stats.isFile()
          console.error chalk.red "#{argv.file} is not a file"
          process.exit 1

        console.log chalk.bold.gray "Processing #{argv.file} with Solver #{argv.solver}"
        input = fs
          .readFileSync argv.file, 'utf8'
          .split "\n"
        console.log chalk.green solvers[argv.solver - 1](input, {
          red: argv.reds
          green: argv.greens
          blue: argv.blues
        })
  }
  # .demandCommand 1, 'You must specify a command'
  .argv
