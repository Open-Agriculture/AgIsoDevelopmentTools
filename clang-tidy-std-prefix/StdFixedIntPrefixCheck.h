#pragma once

#include "clang-tidy/ClangTidyCheck.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"

namespace clang {
namespace tidy {
namespace stdprefix {

class StdFixedIntPrefixCheck : public ClangTidyCheck {
public:
  using ClangTidyCheck::ClangTidyCheck;

  void registerMatchers(ast_matchers::MatchFinder *Finder) override;
  void check(const ast_matchers::MatchFinder::MatchResult &Result) override;
};

} // namespace stdprefix
} // namespace tidy
} // namespace clang
